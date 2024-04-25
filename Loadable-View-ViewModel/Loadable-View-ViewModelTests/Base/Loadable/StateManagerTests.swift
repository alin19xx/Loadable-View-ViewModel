//
//  StateManagerTests.swift
//  Loadable-View-ViewModelTests
//
//  Created by Alex Lin Segarra on 25/4/24.
//

import Combine
import XCTest

class StateManagerTests: XCTestCase {
    var stateManager: StateManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        stateManager = StateManager()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        stateManager = nil
        cancellables = nil
        super.tearDown()
    }

    /// Test StateManager`isLoading`
    /// Expected number of states including initial
    ///
    /// (First load - False | Setup data - True l Finish data setup - False)
    func testLoadingState() {
        
        // Given: A setup with a viewModel and StateManager connected
        let isLoadingPublisher = PassthroughSubject<Bool, Never>()
        let errorPublisher = PassthroughSubject<Error?, Never>()
        
        let viewModel = MockViewModel(isLoading: isLoadingPublisher.eraseToAnyPublisher(),
                                      error: errorPublisher.eraseToAnyPublisher())
        
        stateManager.bindViewModel(viewModel)
        
        let expectation = XCTestExpectation(description: "Waiting for isLoading to update")
        var receivedLoadingStates: [Bool] = []
        
        stateManager.$isLoading
            .sink { isLoading in
                receivedLoadingStates.append(isLoading)
                if receivedLoadingStates.count == 3 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When: Changes to loading state are published
        isLoadingPublisher.send(true)
        isLoadingPublisher.send(false)
        
        // Then: Expected loading states are received
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedLoadingStates, [false, true, false])
    }
    
    
    /// Test error handling for `Network Error`
    func testErrorHandling() {
        // Given: A setup with a viewModel where an error can be sent
        let errorPublisher = PassthroughSubject<Error?, Never>()
        let viewModel = MockViewModel(isLoading: Just(false).eraseToAnyPublisher(),
                                      error: errorPublisher.eraseToAnyPublisher())
        
        stateManager.bindViewModel(viewModel)

        let expectation = XCTestExpectation(description: "Waiting for error handling to update")

        stateManager.$showErrorAlert
            .dropFirst()  // Drop the initial state to only get updates when actually changed.
            .sink { showAlert in
                if showAlert {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When: An error is published through the errorPublisher
        errorPublisher.send(AppError.networkError(message: "Network failure"))
        
        // Then: The error alert state updates
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(stateManager.showErrorAlert)
        XCTAssertEqual(stateManager.errorMessage, "Network failure")
        XCTAssertEqual(stateManager.alertType, .network)
    }
}


class MockViewModel: LoadableViewModel {
    var isLoading: AnyPublisher<Bool, Never>
    var error: AnyPublisher<Error?, Never>

    init(isLoading: AnyPublisher<Bool, Never>, error: AnyPublisher<Error?, Never>) {
        self.isLoading = isLoading
        self.error = error
    }

    func loadData() { }
}

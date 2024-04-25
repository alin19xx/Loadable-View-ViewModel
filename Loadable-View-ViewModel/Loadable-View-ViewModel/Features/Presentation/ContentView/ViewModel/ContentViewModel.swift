//
//  ContentViewModel.swift
//  Loadable-View-ViewModel
//
//  Created by Alex Lin Segarra on 25/4/24.
//

import Foundation
import Combine

class ContentViewModel: LoadableViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()
    private let errorSubject = PassthroughSubject<Error?, Never>()

    var isLoading: AnyPublisher<Bool, Never> { isLoadingSubject.eraseToAnyPublisher() }
    var error: AnyPublisher<Error?, Never> { errorSubject.eraseToAnyPublisher() }
    
    func loadData() {
        isLoadingSubject.send(true)
        Just("")
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .tryMap { data -> String in
                // Simulate different types of errors based on data content or other conditions
                if data.isEmpty {
                    throw AppError.notFound(message: "No data found")
                }
                // You could add more conditions here for other error types
                return data
            }
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isLoadingSubject.send(false)
                case .failure(let error):
                    self?.isLoadingSubject.send(false)
                    self?.errorSubject.send(error)
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}

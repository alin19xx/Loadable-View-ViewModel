//
//  StateManager.swift
//  Loadable-View-ViewModel
//
//  Created by Alex Lin Segarra on 25/4/24.
//

import Combine
import SwiftUI

class StateManager: ObservableObject {
    
    enum AlertType {
        case generic
        case network
        case notFound
        case unauthorized
    }
    
    // Loading properties
    @Published var isLoading: Bool = false
    
    // Alert properties
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var alertType: AlertType = .generic
    
    private var cancellables = Set<AnyCancellable>()
    
    func bindViewModel<ViewModel: LoadableViewModel>(_ viewModel: ViewModel) {
        viewModel.isLoading
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        viewModel.error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                if let error = error as? AppError {
                    self?.assignAlertWith(error)
                }
            }
            .store(in: &cancellables)
    }
    
    // Private methods
    
    private func assignAlertWith(_ error: AppError?) {
        if let appError = error {
            self.errorMessage = appError.localizedDescription
            self.showErrorAlert = true
            
            switch appError {
            case .networkError:
                self.alertType = .network
            case .notFound:
                self.alertType = .notFound
            case .unauthorized:
                self.alertType = .unauthorized
            case .genericError:
                self.alertType = .generic
            }
        }
    }
}

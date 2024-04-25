//
//  LoadableViewModel.swift
//  Loadable-View-ViewModel
//
//  Created by Alex Lin Segarra on 24/4/24.
//

import Combine

protocol LoadableViewModel: ObservableObject {
    var isLoading: AnyPublisher<Bool, Never> { get }
    var error: AnyPublisher<Error?, Never> { get }
    func loadData()
}

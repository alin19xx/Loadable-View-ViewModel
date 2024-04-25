//
//  LoadableView.swift
//  Loadable-View-ViewModel
//
//  Created by Alex Lin Segarra on 24/4/24.
//

import SwiftUI
import Combine

struct LoadableView<Content: View, ViewModel: LoadableViewModel>: View {
    
    @ObservedObject private var stateManager = StateManager()
    
    @ObservedObject var viewModel: ViewModel
    let content: () -> Content
    
    init(viewModel: ViewModel, content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
        
        stateManager.bindViewModel(viewModel)
        viewModel.loadData()
    }

    var body: some View {
        loadableContent
            // Can be moved as a custom modifier
            .alert(isPresented: $stateManager.showErrorAlert) {
                switch stateManager.alertType {
                case .network:
                    return Alert(title: Text("Network Error"), message: Text(stateManager.errorMessage))
                case .notFound:
                    return Alert(title: Text("Not Found"), message: Text(stateManager.errorMessage))
                case .unauthorized:
                    return Alert(title: Text("Unauthorized"), message: Text(stateManager.errorMessage))
                case .generic:
                    return Alert(title: Text("Error"), message: Text(stateManager.errorMessage))
                }
            }
    }
    
    @ViewBuilder
    private var loadableContent: some View {
        ZStack {
            if stateManager.isLoading {
                ProgressView("Loading...")
            } else {
                content()
            }
        }
    }
}

#Preview {
    LoadableView(viewModel: ContentViewModel()) {
        ContentView()
    }
}

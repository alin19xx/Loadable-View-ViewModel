//
//  ContentView.swift
//  Loadable-View-ViewModel
//
//  Created by Alex Lin Segarra on 24/4/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        LoadableView(viewModel: viewModel) {
            Text("Data loaded successfully")
        }
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  Loadable-View-ViewModel
//
//  Created by Alex Lin Segarra on 24/4/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        LoadableView(viewModel: ContentViewModel()) {
            Text("Data loaded successfully")
        }
    }
}

#Preview {
    ContentView()
}

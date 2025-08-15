//
//  MorakApp.swift
//  Morak
//
//  Created by Hong jeongmin on 8/4/25.
//

import SwiftUI

@main
struct MorakApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(appState)
        }
    }
}

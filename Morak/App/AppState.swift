//
//  AppState.swift
//  Morak
//
//  Created by Hong jeongmin on 8/12/25.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .post
}

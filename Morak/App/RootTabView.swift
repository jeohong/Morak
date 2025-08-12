//
//  RootTabView.swift
//  Morak
//
//  Created by Hong jeongmin on 8/12/25.
//

import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            PostView()
                .tabItem { Label(AppTab.post.title, systemImage: AppTab.post.systemImage) }
                .tag(AppTab.post)

            ChatView()
                .tabItem { Label(AppTab.chat.title, systemImage: AppTab.chat.systemImage) }
                .tag(AppTab.chat)

            FriendsView()
                .tabItem { Label(AppTab.friends.title, systemImage: AppTab.friends.systemImage) }
                .tag(AppTab.friends)

            SettingView()
                .tabItem { Label(AppTab.setting.title, systemImage: AppTab.setting.systemImage) }
                .tag(AppTab.setting)
        }
    }
}

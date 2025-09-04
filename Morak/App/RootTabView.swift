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
                .tabItem { 
                    Image(AppTab.post.systemImage)
                        .renderingMode(.template)
                    Text(AppTab.post.title)
                }
                .tag(AppTab.post)

            ChatView()
                .tabItem { 
                    Image(AppTab.chat.systemImage)
                        .renderingMode(.template)
                    Text(AppTab.chat.title)
                }
                .tag(AppTab.chat)

            FriendsView()
                .tabItem { 
                    Image(AppTab.friends.systemImage)
                        .renderingMode(.template)
                    Text(AppTab.friends.title)
                }
                .tag(AppTab.friends)

            SettingView()
                .tabItem { 
                    Image(AppTab.setting.systemImage)
                        .renderingMode(.template)
                    Text(AppTab.setting.title)
                }
                .tag(AppTab.setting)
        }
        .accentColor(.secondary)
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = UIColor(Color.tabBackground)
            tabBarAppearance.selectionIndicatorTintColor = UIColor(Color.primary)
            
            // Configure item appearance
            tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.primary)
            tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.primary)]
            tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.textSecondary)
            tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.textSecondary)]
            
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

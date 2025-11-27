//
//  FriendsView.swift
//  Morak
//
//  Created by Hong jeongmin on 8/12/25.
//

import SwiftUI

struct FriendsView: View {
    // MARK: - Properties
    @StateObject private var viewModel = FriendsViewModel()

    var body: some View {
        VStack(spacing: 0) {
            // Segment Tab
            FriendsTabBar(
                selectedTab: $viewModel.selectedTab,
                requestBadgeCount: viewModel.requestBadgeCount
            )
            .padding(.horizontal, 16)
            .padding(.top, 8)

            // Tab Content
            TabView(selection: $viewModel.selectedTab) {
                FriendSearchTabView(
                    searchText: $viewModel.searchText,
                    searchResults: viewModel.searchResults,
                    onSearch: viewModel.searchFriends
                )
                .tag(FriendsTab.search)

                FriendListTabView(
                    friends: viewModel.friends,
                    onProfileTap: viewModel.navigateToProfile
                )
                .tag(FriendsTab.friends)

                FriendRequestTabView(
                    requests: viewModel.friendRequests,
                    onAccept: viewModel.acceptFriendRequest,
                    onReject: viewModel.rejectFriendRequest
                )
                .tag(FriendsTab.requests)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(Color.postBackground.ignoresSafeArea())
    }
}

// MARK: - Friends Tab Bar
struct FriendsTabBar: View {
    @Binding var selectedTab: FriendsTab
    let requestBadgeCount: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(FriendsTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Text(tab.title)
                            .font(.pretendard.mediumTextMedium)
                            .foregroundColor(selectedTab == tab ? .white : .textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                selectedTab == tab
                                    ? Color.main
                                    : Color.clear
                            )
                            .cornerRadius(20)

                        // Badge for requests tab
                        if tab == .requests && requestBadgeCount > 0 {
                            Text("\(requestBadgeCount)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 18, height: 18)
                                .background(Color.orangeButton)
                                .clipShape(Circle())
                                .offset(x: -8, y: -2)
                        }
                    }
                }
            }
        }
        .padding(4)
        .background(Color.cardBackground)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    FriendsView()
}

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
    @ObservedObject private var authManager = AuthManager.shared

    // UI State
    @State private var showLoginPrompt: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var navigateToLogin: Bool = false
    @State private var friendToDelete: Friend?

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
                    onSearch: viewModel.searchFriends,
                    onAddFriend: handleAddFriend
                )
                .tag(FriendsTab.search)

                FriendListTabView(
                    friends: viewModel.friends,
                    onDeleteFriend: handleDeleteFriend
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
        .onAppear {
            Task {
                await viewModel.refreshData()
            }
        }
        .onChange(of: authManager.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                // 로그인 후 데이터 새로고침
                Task {
                    await viewModel.refreshData()
                }
            } else {
                // 로그아웃 시 데이터 초기화
                viewModel.clearData()
            }
        }
        .onChange(of: viewModel.errorMessage) { errorMessage in
            if errorMessage != nil {
                showErrorAlert = true
            }
        }
        .onChange(of: showErrorAlert) { isShowing in
            if !isShowing {
                viewModel.errorMessage = nil
            }
        }
        .customAlert(
            isPresented: $showLoginPrompt,
            config: CustomAlertConfig(
                message: "로그인 하고 이용해 주세요",
                primaryButton: AlertButton(title: "확인", style: .primary) {
                    navigateToLogin = true
                },
                secondaryButton: AlertButton(title: "취소", style: .cancel)
            )
        )
        .customAlert(
            isPresented: $showErrorAlert,
            config: CustomAlertConfig(
                title: "알림",
                message: viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.",
                primaryButton: AlertButton(title: "확인", style: .primary)
            )
        )
        .customAlert(
            isPresented: $showDeleteConfirmation,
            config: CustomAlertConfig(
                title: "친구 삭제",
                message: "\(friendToDelete?.nickname ?? "")님을 삭제하실래요?",
                primaryButton: AlertButton(title: "삭제", style: .destructive) {
                    if let friend = friendToDelete {
                        viewModel.deleteFriend(friend)
                    }
                    friendToDelete = nil
                },
                secondaryButton: AlertButton(title: "취소", style: .cancel) {
                    friendToDelete = nil
                }
            )
        )
        .fullScreenCover(isPresented: $navigateToLogin) {
            LoginView()
        }
    }

    // MARK: - Actions
    private func handleAddFriend(_ friend: Friend) {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        Task {
            _ = await viewModel.sendFriendRequest(to: friend)
        }
    }

    private func handleDeleteFriend(_ friend: Friend) {
        friendToDelete = friend
        showDeleteConfirmation = true
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

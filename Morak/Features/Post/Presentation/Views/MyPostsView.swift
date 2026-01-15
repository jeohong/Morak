//
//  MyPostsView.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import SwiftUI

struct MyPostsView: View {
    // MARK: - Properties
    @StateObject private var viewModel = MyPostsViewModel.makeDefault()
    @ObservedObject private var authManager = AuthManager.shared

    // UI State
    @State private var showErrorAlert: Bool = false
    @State private var showLoginPrompt: Bool = false
    @State private var showLoginView: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            FilterSectionView(
                selectedFilter: $viewModel.selectedFilter,
                onFilterChange: { filter in
                    viewModel.changeFilter(filter)
                }
            )

            if viewModel.posts.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, post in
                            PostCardView(
                                post: post,
                                authManager: authManager,
                                showLoginPrompt: $showLoginPrompt,
                                onLikeTap: { postId in
                                    Task {
                                        await viewModel.toggleLike(postId: postId)
                                    }
                                },
                                onPostUpdated: { updatedPost in
                                    viewModel.updatePost(updatedPost)
                                },
                                onPostDeleted: { deletedPostId in
                                    viewModel.removePost(deletedPostId)
                                },
                                onUserBlocked: nil
                            )
                            .onAppear {
                                let threshold = max(0, viewModel.posts.count - 3)
                                if index >= threshold {
                                    Task {
                                        await viewModel.fetchMyPosts(sortBy: viewModel.selectedFilter, refresh: false)
                                    }
                                }
                            }
                        }

                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
        }
        .background(Color.postBackground.ignoresSafeArea())
        .navigationTitle("내가 쓴 게시물")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.light, for: .navigationBar)
        .tint(.black)
        .onAppear {
            viewModel.loadInitialDataIfNeeded()
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
            isPresented: $showErrorAlert,
            config: CustomAlertConfig(
                title: "오류",
                message: viewModel.errorMessage ?? "알 수 없는 오류가 발생했습니다.",
                primaryButton: AlertButton(title: "확인", style: .primary)
            )
        )
        .customAlert(
            isPresented: $showLoginPrompt,
            config: CustomAlertConfig(
                message: "로그인 하고 이용해 주세요",
                primaryButton: AlertButton(title: "확인", style: .primary) {
                    showLoginView = true
                },
                secondaryButton: AlertButton(title: "취소", style: .cancel)
            )
        )
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView()
        }
        .tokenExpirationAlert(isPresented: $viewModel.showTokenExpiredAlert)
    }

    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "square.and.pencil")
                .font(.system(size: 48))
                .foregroundColor(.textSecondary)

            Text("작성한 게시물이 없습니다")
                .font(.pretendard.mediumTextRegular)
                .foregroundColor(.textSecondary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        MyPostsView()
    }
}

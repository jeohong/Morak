//
//  PostView.swift
//  Morak
//
//  Created by Hong jeongmin on 8/12/25.
//

import SwiftUI

struct PostView: View {
    @StateObject private var viewModel = PostViewModel.makeDefault()
    @ObservedObject private var authManager = AuthManager.shared
    @State private var selectedFilter: FilterOption = .latest
    @State private var showLoginView: Bool = false
    @State private var previousLoginState: Bool = false
    @State private var previousIsLoggedIn: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var showLoginPrompt: Bool = false
    @State private var showCreatePost: Bool = false
    @State private var hasInitialLoaded: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                PostHeaderView(authManager: authManager, showLoginPrompt: $showLoginPrompt, showCreatePost: $showCreatePost)
                
                FilterSectionView(
                    selectedFilter: $selectedFilter,
                    onFilterChange: { filter in
                        Task {
                            await viewModel.fetchPosts(sortBy: filter, refresh: true)
                        }
                    }
                )
                
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
                                }
                            )
                                .onAppear {
                                    // 마지막 아이템이거나 마지막에서 3번째 아이템이 나타나면 다음 페이지 로드
                                    let threshold = max(0, viewModel.posts.count - 3)
                                    if index >= threshold && !viewModel.isLoading && viewModel.hasMorePages {
                                        Task {
                                            await viewModel.fetchPosts(sortBy: selectedFilter, refresh: false)
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
                .background(Color.postBackground)
            }
            .background(Color.postBackground.ignoresSafeArea())
            .onAppear {
                previousIsLoggedIn = authManager.isLoggedIn

                if !hasInitialLoaded {
                    hasInitialLoaded = true
                    Task {
                        await viewModel.fetchPosts(sortBy: selectedFilter)
                    }
                }
            }
            .onChange(of: showLoginView) { newValue in
                if previousLoginState == true && newValue == false {
                    authManager.checkLoginStatus()
                    let currentLoginState = authManager.isLoggedIn
                    
                    if previousIsLoggedIn == currentLoginState {
                        Task {
                            await viewModel.fetchPosts(sortBy: selectedFilter, refresh: true)
                        }
                    }
                }
                previousLoginState = newValue
            }
            .onChange(of: authManager.isLoggedIn) { newValue in
                if previousIsLoggedIn != newValue {
                    Task {
                        await viewModel.fetchPosts(sortBy: selectedFilter, refresh: true)
                    }
                }
                previousIsLoggedIn = newValue
            }
            .fullScreenCover(isPresented: $showLoginView) {
                LoginView()
            }
            .navigationDestination(isPresented: $showCreatePost) {
                CreatePostView(onPostCreated: {
                    Task {
                        await viewModel.fetchPosts(sortBy: selectedFilter, refresh: true)
                    }
                })
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
            .tokenExpirationAlert(isPresented: $viewModel.showTokenExpiredAlert)
        }
    }
}

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

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                PostHeaderView(authManager: authManager, showLoginView: $showLoginView)
                
                FilterSectionView(
                    selectedFilter: $selectedFilter,
                    onFilterChange: { filter in
                        Task {
                            await viewModel.fetchPosts(sortBy: filter, refresh: true)
                        }
                    }
                )
                
                // 포스트 리스트
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, post in
                            PostCardView(post: post, authManager: authManager, showLoginView: $showLoginView)
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
            .task {
                print("🚀 [PostView] 화면 로드 - 초기 데이터 가져오기 시작")
                await viewModel.fetchPosts(sortBy: selectedFilter)
            }
            .onAppear {
                // 초기 로그인 상태 저장 (onChange가 앱 시작 시 트리거되지 않도록)
                previousIsLoggedIn = authManager.isLoggedIn
            }
            .onChange(of: showLoginView) { newValue in
                // LoginView에서 돌아올 때 (true -> false)
                if previousLoginState == true && newValue == false {
                    // 로그인 상태 확인
                    authManager.checkLoginStatus()
                    if authManager.isLoggedIn {
                        print("🔄 [PostView] 로그인 완료 - 데이터 새로고침")
                        Task {
                            await viewModel.fetchPosts(sortBy: selectedFilter, refresh: true)
                        }
                    } else {
                        print("ℹ️ [PostView] 로그인하지 않고 돌아옴")
                    }
                }
                // 현재 상태를 이전 상태로 저장
                previousLoginState = newValue
            }
            .onChange(of: authManager.isLoggedIn) { newValue in
                // 로그인 상태가 변경되었는지 확인
                if previousIsLoggedIn != newValue {
                    if newValue {
                        // 로그인 완료 (false -> true)
                        print("🔄 [PostView] 로그인 완료 - 데이터 새로고침")
                    } else {
                        // 로그아웃 완료 (true -> false)
                        print("🔄 [PostView] 로그아웃 완료 - 데이터 새로고침")
                    }
                    Task {
                        await viewModel.fetchPosts(sortBy: selectedFilter, refresh: true)
                    }
                }
                // 현재 상태를 이전 상태로 저장
                previousIsLoggedIn = newValue
            }
            .navigationDestination(isPresented: $showLoginView) {
                LoginView()
            }
        }
    }
}

// MARK: - Filter Section View
struct FilterSectionView: View {
    @Binding var selectedFilter: FilterOption
    let onFilterChange: (FilterOption) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // 필터 드롭다운 버튼
            Menu {
                ForEach(FilterOption.allCases, id: \.self) { option in
                    Button(action: {
                        selectedFilter = option
                        onFilterChange(option)
                    }) {
                        HStack {
                            Text(option.title)
                            if selectedFilter == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.textSecondary)
                    
                    Text(selectedFilter.title)
                        .font(.pretendard.mediumTextRegular)
                        .foregroundColor(.textPrimary)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.cardBackground)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                )
            }
            
            Spacer()
            
            // 검색 버튼
            Button(action: {
                print("검색")
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.textSecondary)
                    .frame(width: 40, height: 40)
                    .background(Color.cardBackground)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

// MARK: - Post Card View
struct PostCardView: View {
    let post: Post
    @ObservedObject var authManager: AuthManager
    @Binding var showLoginView: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 닉네임과 수정됨 표시
            HStack {
                Text(post.nickname)
                    .font(.pretendard.mediumTextSemiBold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                if post.isModified {
                    Text("수정됨")
                        .font(.pretendard.smallTextRegular)
                        .foregroundColor(.textSecondary)
                }
            }
            
            Text(post.content)
                .font(.pretendard.mediumTextRegular)
                .foregroundColor(.textSecondary)
                .lineLimit(6)
                .multilineTextAlignment(.leading)
            
            // 시간, 좋아요, 댓글
            HStack {
                Text(post.formattedCreatedAt)
                    .font(.pretendard.smallTextRegular)
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                HStack(spacing: 12) {
                    // 좋아요 버튼
                    Button(action: {
                        handleLikeButton()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: post.isLikedByMe ? "heart.fill" : "heart")
                                .font(.system(size: 14))
                                .foregroundColor(post.isLikedByMe ? .red : .textSecondary)
                            Text("\(post.likeCount)")
                                .font(.pretendard.smallTextRegular)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    
                    // 댓글 버튼
                    Button(action: {
                        handleCommentButton()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "bubble.right")
                                .font(.system(size: 14))
                            Text("\(post.commentCount)")
                                .font(.pretendard.smallTextRegular)
                        }
                        .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .onTapGesture {
            handlePostTap()
        }
    }
    
    private func handlePostTap() {
        // 로그인 상태 확인
        guard !authManager.requiresLogin else {
            print("🔒 [PostCardView] 로그인이 필요합니다 - LoginView로 이동")
            showLoginView = true
            return
        }

        // 로그인된 경우 포스트 상세로 이동
        print("📖 [PostCardView] 포스트 \(post.id) 상세 화면으로 이동")
        // TODO: 포스트 상세 화면 내비게이션 구현
    }
    
    private func handleCommentButton() {
        // 로그인 상태 확인
        guard !authManager.requiresLogin else {
            print("🔒 [PostCardView] 로그인이 필요합니다 - LoginView로 이동")
            showLoginView = true
            return
        }

        // 로그인된 경우 댓글 화면으로 이동
        print("💬 [PostCardView] 포스트 \(post.id) 댓글 화면으로 이동")
        // TODO: 댓글 화면 내비게이션 구현
    }
    
    private func handleLikeButton() {
        // 로그인 상태 확인
        guard !authManager.requiresLogin else {
            print("🔒 [PostCardView] 로그인이 필요합니다 - LoginView로 이동")
            showLoginView = true
            return
        }

        // 로그인된 경우 좋아요 처리
        print("❤️ [PostCardView] 좋아요 클릭: \(post.id)")
        // TODO: 좋아요 API 호출
    }
}

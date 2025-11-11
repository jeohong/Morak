//
//  PostDetailView.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import SwiftUI

struct PostDetailView: View {
    // MARK: - Properties
    let postId: Int
    let onPostUpdated: ((Post) -> Void)?
    @StateObject private var viewModel: PostDetailViewModel
    @ObservedObject private var authManager = AuthManager.shared
    @Environment(\.dismiss) private var dismiss

    // UI State
    @State private var showErrorAlert: Bool = false
    @State private var showLoginPrompt: Bool = false

    init(postId: Int, onPostUpdated: ((Post) -> Void)? = nil) {
        self.postId = postId
        self.onPostUpdated = onPostUpdated
        _viewModel = StateObject(wrappedValue: PostDetailViewModel.makeDefault(postId: postId))
    }

    var body: some View {
        ZStack {
            Color.postBackground
                .ignoresSafeArea()

            if viewModel.isLoading && viewModel.post == nil {
                ProgressView()
            } else if let post = viewModel.post {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Header
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

                        // Content - 모든 글 표시
                        Text(post.content)
                            .font(.pretendard.mediumTextRegular)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.leading)

                        // Footer
                        HStack {
                            Text(post.formattedCreatedAt)
                                .font(.pretendard.smallTextRegular)
                                .foregroundColor(.textSecondary)

                            Spacer()

                            HStack(spacing: 12) {
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

                                HStack(spacing: 4) {
                                    Image(systemName: "eye")
                                        .font(.system(size: 14))
                                    Text("\(post.viewCount)")
                                        .font(.pretendard.smallTextRegular)
                                }
                                .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
        }
        .navigationTitle(viewModel.post.map { "\($0.nickname)님의 이야기" } ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.system(size: 17, weight: .semibold))
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPostDetail()
            }
        }
        .onDisappear {
            // 변경된 포스트 데이터를 콜백으로 전달
            if let updatedPost = viewModel.post {
                onPostUpdated?(updatedPost)
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
        .onChange(of: viewModel.showTokenExpiredAlert) { isShowing in
            // 토큰 만료 팝업이 닫히면 (확인 버튼 또는 외부 클릭) 메인으로 복귀
            if !isShowing {
                dismiss()
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
                primaryButton: AlertButton(title: "확인", style: .primary),
                secondaryButton: AlertButton(title: "취소", style: .cancel)
            )
        )
        .tokenExpirationAlert(isPresented: $viewModel.showTokenExpiredAlert)
    }

    private func handleCommentButton() {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        print("💬 [PostDetailView] 포스트 \(postId) 댓글 화면으로 이동")
        // TODO: 댓글 화면 내비게이션 구현
    }

    private func handleLikeButton() {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        Task {
            await viewModel.toggleLike()
        }
    }
}

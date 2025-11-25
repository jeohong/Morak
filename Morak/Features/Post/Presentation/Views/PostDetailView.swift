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
    let onPostDeleted: ((Int) -> Void)?
    let shouldFocusComment: Bool
    @StateObject private var viewModel: PostDetailViewModel
    @StateObject private var commentViewModel: CommentViewModel
    @ObservedObject private var authManager = AuthManager.shared
    @Environment(\.dismiss) private var dismiss

    // UI State
    @State private var showErrorAlert: Bool = false
    @State private var showLoginPrompt: Bool = false
    @State private var navigateToLogin: Bool = false
    @State private var commentText: String = ""
    @State private var showDeleteConfirmation: Bool = false
    @State private var navigateToEdit: Bool = false
    @FocusState private var isCommentInputFocused: Bool

    init(postId: Int, onPostUpdated: ((Post) -> Void)? = nil, onPostDeleted: ((Int) -> Void)? = nil, shouldFocusComment: Bool = false) {
        self.postId = postId
        self.onPostUpdated = onPostUpdated
        self.onPostDeleted = onPostDeleted
        self.shouldFocusComment = shouldFocusComment
        _viewModel = StateObject(wrappedValue: PostDetailViewModel.makeDefault(postId: postId))
        _commentViewModel = StateObject(wrappedValue: CommentViewModel.makeDefault(postId: postId))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading && viewModel.post == nil {
                Spacer()
                ProgressView()
                Spacer()
            } else if let post = viewModel.post {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            // Post Card
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

                            // Comment Section
                            CommentSectionView(
                                viewModel: commentViewModel,
                                showLoginPrompt: $showLoginPrompt
                            )
                            .padding(.top, 16)
                        }
                    }
                    .background(Color.postBackground)
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded { _ in
                                if isCommentInputFocused {
                                    dismissKeyboard()
                                }
                            }
                    )
                    .onChange(of: commentViewModel.replyingTo) { replyingTo in
                        if let comment = replyingTo {
                            // 키보드 올리기
                            isCommentInputFocused = true

                            // 해당 댓글로 스크롤 (입력창 바로 위에 위치)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation {
                                    scrollProxy.scrollTo(comment.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                    .onChange(of: commentViewModel.editingComment) { editingComment in
                        if let comment = editingComment {
                            // 기존 댓글 내용을 입력창에 설정
                            commentText = comment.content
                            // 키보드 올리기
                            isCommentInputFocused = true

                            // 해당 댓글로 스크롤
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation {
                                    scrollProxy.scrollTo(comment.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                CommentInputView(
                    text: $commentText,
                    onSubmit: handleCommentSubmit,
                    replyingTo: commentViewModel.replyingTo,
                    editingComment: commentViewModel.editingComment,
                    onCancelReply: {
                        commentViewModel.replyingTo = nil
                        commentText = ""
                    },
                    onCancelEdit: {
                        commentViewModel.editingComment = nil
                        commentText = ""
                    },
                    onLoginRequired: {
                        showLoginPrompt = true
                    },
                    focusedField: $isCommentInputFocused
                )
            }
        }
        .background(Color.postBackground.ignoresSafeArea())
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

            if viewModel.isMyPost {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            handleEditPost()
                        }) {
                            Label("수정", systemImage: "pencil")
                        }

                        Button(role: .destructive, action: {
                            showDeleteConfirmation = true
                        }) {
                            Label("삭제", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPostDetail()
                await commentViewModel.fetchComments(sortBy: commentViewModel.selectedSort)

                // 댓글 작성 모드로 진입
                if shouldFocusComment {
                    if authManager.requiresLogin {
                        showLoginPrompt = true
                    } else {
                        // 약간의 딜레이 후 키보드 올리기 (화면 로딩 후)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isCommentInputFocused = true
                        }
                    }
                }
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
        .onChange(of: commentViewModel.showTokenExpiredAlert) { isShowing in
            // 댓글에서 토큰 만료 시에도 메인으로 복귀
            if !isShowing {
                dismiss()
            }
        }
        .onChange(of: commentViewModel.errorMessage) { errorMessage in
            // 댓글 에러 메시지도 처리
            if errorMessage != nil {
                viewModel.errorMessage = errorMessage
            }
        }
        .onChange(of: viewModel.isDeleted) { isDeleted in
            // 삭제 성공 시 메인 화면으로 돌아가기
            if isDeleted {
                onPostDeleted?(postId)
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
                primaryButton: AlertButton(title: "확인", style: .primary) {
                    navigateToLogin = true
                },
                secondaryButton: AlertButton(title: "취소", style: .cancel)
            )
        )
        .fullScreenCover(isPresented: $navigateToLogin) {
            LoginView()
        }
        .navigationDestination(isPresented: $navigateToEdit) {
            if let post = viewModel.post {
                EditPostView(postId: post.id, initialContent: post.content) {
                    Task {
                        await viewModel.fetchPostDetail()
                    }
                }
            }
        }
        .tokenExpirationAlert(isPresented: $viewModel.showTokenExpiredAlert)
        .customAlert(
            isPresented: $showDeleteConfirmation,
            config: CustomAlertConfig(
                title: "게시글 삭제",
                message: "정말로 이 게시글을 삭제하시겠습니까?",
                primaryButton: AlertButton(title: "삭제", style: .destructive) {
                    handleDeletePost()
                },
                secondaryButton: AlertButton(title: "취소", style: .cancel)
            )
        )
        .customAlert(
            isPresented: $commentViewModel.showDeleteConfirmation,
            config: CustomAlertConfig(
                title: "댓글 삭제",
                message: "정말로 이 댓글을 삭제하시겠습니까?",
                primaryButton: AlertButton(title: "삭제", style: .destructive) {
                    handleCommentDelete()
                },
                secondaryButton: AlertButton(title: "취소", style: .cancel)
            )
        )
    }
    
    private func dismissKeyboard() {
        isCommentInputFocused = false
        commentText = ""
        commentViewModel.replyingTo = nil
        commentViewModel.editingComment = nil
    }
    
    private func handleCommentButton() {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }
        
        isCommentInputFocused = true
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
    
    private func handleCommentSubmit() {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        guard !commentText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        // 수정 모드인 경우
        if let editingComment = commentViewModel.editingComment {
            Task {
                let success = await commentViewModel.updateComment(
                    commentId: editingComment.id,
                    content: commentText,
                    parentId: editingComment.parentId
                )

                if success {
                    commentText = ""
                    commentViewModel.editingComment = nil
                    isCommentInputFocused = false
                }
            }
            return
        }

        // 새 댓글 또는 답글 작성
        let parentId = commentViewModel.replyingTo?.id

        Task {
            let success = await commentViewModel.createComment(
                content: commentText,
                parentId: parentId
            )

            if success {
                commentText = ""
                commentViewModel.replyingTo = nil
                isCommentInputFocused = false
            }
        }
    }

    private func handleEditPost() {
        navigateToEdit = true
    }

    private func handleDeletePost() {
        Task {
            await viewModel.deletePost()
        }
    }

    private func handleCommentDelete() {
        guard let comment = commentViewModel.commentToDelete else { return }

        Task {
            await commentViewModel.deleteComment(commentId: comment.id, parentId: comment.parentId)
        }

        commentViewModel.commentToDelete = nil
    }
}

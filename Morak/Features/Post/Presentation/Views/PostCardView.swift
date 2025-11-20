//
//  PostCardView.swift
//  Morak
//
//  Created by 홍정민 on 11/7/25.
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    @ObservedObject var authManager: AuthManager
    @Binding var showLoginPrompt: Bool
    let onLikeTap: (Int) -> Void
    let onPostUpdated: ((Post) -> Void)?
    let onPostDeleted: ((Int) -> Void)?

    @State private var showPostDetail: Bool = false
    @State private var shouldFocusComment: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
        .onTapGesture {
            handlePostTap()
        }
        .navigationDestination(isPresented: $showPostDetail) {
            PostDetailView(
                postId: post.id,
                onPostUpdated: onPostUpdated,
                onPostDeleted: onPostDeleted,
                shouldFocusComment: shouldFocusComment
            )
        }
    }

    private func handlePostTap() {
        shouldFocusComment = false
        showPostDetail = true
    }

    private func handleCommentButton() {
        shouldFocusComment = true
        showPostDetail = true
    }

    private func handleLikeButton() {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }
        
        onLikeTap(post.id)
    }
}

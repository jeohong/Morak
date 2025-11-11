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
    }
    
    private func handlePostTap() {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        print("📖 [PostCardView] 포스트 \(post.id) 상세 화면으로 이동")
        // TODO: 포스트 상세 화면 내비게이션 구현
    }

    private func handleCommentButton() {
        // 로그인 상태 확인
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        print("💬 [PostCardView] 포스트 \(post.id) 댓글 화면으로 이동")
        // TODO: 댓글 화면 내비게이션 구현
    }

    private func handleLikeButton() {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }
        
        onLikeTap(post.id)
    }
}

//
//  CommentItemView.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import SwiftUI

struct CommentItemView: View {
    let comment: Comment
    let isReply: Bool
    let onLikeTap: () -> Void
    let onReportTap: () -> Void
    let onReplyTap: (() -> Void)?
    let onToggleReplies: (() -> Void)?
    let isExpanded: Bool

    @ObservedObject var authManager = AuthManager.shared

    private var isMyComment: Bool {
        guard let myUserIdString = authManager.currentUser?.id,
              let myUserId = Int(myUserIdString) else {
            return false
        }
        return comment.userId == myUserId
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                // 대댓글이면 화살표 아이콘 표시
                if isReply {
                    Image(systemName: "arrow.turn.down.right")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                        .padding(.top, 2)
                }

                // 프로필 아이콘
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.textSecondary)

                VStack(alignment: .leading, spacing: 4) {
                    // 닉네임 및 액션 버튼
                    HStack {
                        Text(comment.nickname)
                            .font(.pretendard.mediumTextSemiBold)
                            .foregroundColor(.textPrimary)

                        Spacer()

                        // 좋아요 버튼
                        Button(action: onLikeTap) {
                            HStack(spacing: 4) {
                                Image(systemName: comment.isLikedByMe ? "heart.fill" : "heart")
                                    .font(.system(size: 12))
                                    .foregroundColor(comment.isLikedByMe ? .red : .textSecondary)
                                Text("\(comment.likeCount)")
                                    .font(.pretendard.smallTextRegular)
                                    .foregroundColor(.textSecondary)
                            }
                        }

                        // 더보기 메뉴
                        Menu {
                            if isMyComment {
                                Button(action: {
                                    print("✏️ [CommentItemView] 댓글 \(comment.id) 수정")
                                    // TODO: 댓글 수정 기능 구현
                                }) {
                                    Label("수정", systemImage: "pencil")
                                }
                                Button(role: .destructive, action: {
                                    print("🗑️ [CommentItemView] 댓글 \(comment.id) 삭제")
                                    // TODO: 댓글 삭제 기능 구현
                                }) {
                                    Label("삭제", systemImage: "trash")
                                }
                            } else {
                                Button(role: .destructive, action: onReportTap) {
                                    Label("신고", systemImage: "exclamationmark.triangle")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                    }

                    // 댓글 내용
                    if comment.deleted {
                        Text("삭제된 댓글입니다")
                            .font(.pretendard.smallTextRegular)
                            .foregroundColor(.textSecondary)
                            .italic()
                    } else {
                        Text(comment.content)
                            .font(.pretendard.smallTextRegular)
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)
                    }

                    // 시간 및 수정 뱃지
                    HStack(spacing: 8) {
                        Text(comment.formattedCreatedAt)
                            .font(.pretendard.smallTextRegular)
                            .foregroundColor(.textSecondary)

                        if comment.isModified && !comment.deleted {
                            Text("(수정됨)")
                                .font(.pretendard.smallTextRegular)
                                .foregroundColor(.textSecondary)
                        }

                        // 답글 버튼 (루트 댓글이고 삭제되지 않은 경우만)
                        if !isReply && !comment.deleted, let onReplyTap = onReplyTap {
                            Text("·")
                                .font(.pretendard.smallTextRegular)
                                .foregroundColor(.textSecondary)

                            Button(action: onReplyTap) {
                                Text("답글")
                                    .font(.pretendard.smallTextBold)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }

            // 답글 보기/접기 버튼 (루트 댓글이고 대댓글이 있을 때만)
            if !isReply, comment.hasChildren, let onToggleReplies = onToggleReplies {
                Button(action: onToggleReplies) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.turn.down.right")
                            .font(.system(size: 10))
                        Text(isExpanded ? "답글 접기" : "답글 보기")
                            .font(.pretendard.smallTextRegular)
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10))
                    }
                    .foregroundColor(.textSecondary)
                }
                .padding(.leading, isReply ? 40 : 32)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

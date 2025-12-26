//
//  CommentSectionView.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import SwiftUI

struct CommentSectionView: View {
    @ObservedObject var viewModel: CommentViewModel
    @ObservedObject var authManager = AuthManager.shared
    @Binding var showLoginPrompt: Bool

    // deleted == true && hasChildren == false 인 댓글 필터링
    private var visibleComments: [Comment] {
        viewModel.comments.filter { !$0.deleted || $0.hasChildren }
    }

    private func visibleReplies(for parentId: Int) -> [Comment] {
        (viewModel.repliesMap[parentId] ?? []).filter { !$0.deleted }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("댓글 \(viewModel.totalComments)개")
                    .font(.pretendard.mediumTextSemiBold)
                    .foregroundColor(.textPrimary)

                Spacer()
                
                Menu {
                    ForEach(CommentSortOption.allCases, id: \.self) { option in
                        Button(action: {
                            viewModel.changeSort(option)
                        }) {
                            HStack {
                                Text(option.title)
                                if viewModel.selectedSort == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.selectedSort.title)
                            .font(.pretendard.smallTextRegular)
                            .foregroundColor(.textPrimary)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()
            
            if visibleComments.isEmpty && !viewModel.isLoading {
                VStack(spacing: 8) {
                    Text("첫 댓글을 남겨보세요")
                        .font(.pretendard.mediumTextRegular)
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(Array(visibleComments.enumerated()), id: \.element.id) { index, comment in
                        VStack(spacing: 0) {
                            CommentItemView(
                                comment: comment,
                                isReply: false,
                                onLikeTap: {
                                    handleCommentLike(commentId: comment.id)
                                },
                                onReportTap: {
                                    handleCommentReport(comment: comment)
                                },
                                onEditTap: {
                                    handleEdit(comment: comment)
                                },
                                onDeleteTap: {
                                    handleDelete(comment: comment)
                                },
                                onReplyTap: {
                                    handleReply(to: comment)
                                },
                                onToggleReplies: comment.hasChildren ? {
                                    viewModel.toggleReplies(for: comment.id)
                                } : nil,
                                isExpanded: viewModel.expandedComments.contains(comment.id)
                            )
                            .id(comment.id)
                            
                            if viewModel.expandedComments.contains(comment.id) {
                                let replies = visibleReplies(for: comment.id)
                                ForEach(replies) { reply in
                                    CommentItemView(
                                        comment: reply,
                                        isReply: true,
                                        onLikeTap: {
                                            handleCommentLike(commentId: reply.id)
                                        },
                                        onReportTap: {
                                            handleCommentReport(comment: reply)
                                        },
                                        onEditTap: {
                                            handleEdit(comment: reply)
                                        },
                                        onDeleteTap: {
                                            handleDelete(comment: reply)
                                        },
                                        onReplyTap: nil,
                                        onToggleReplies: nil,
                                        isExpanded: false
                                    )
                                    .background(Color.gray.opacity(0.05))
                                }
                                
                                if let hasMore = viewModel.repliesHasMore[comment.id], hasMore {
                                    Button(action: {
                                        Task {
                                            await viewModel.loadReplies(for: comment.id, loadMore: true)
                                        }
                                    }) {
                                        HStack {
                                            if viewModel.loadingReplies.contains(comment.id) {
                                                ProgressView()
                                                    .scaleEffect(0.8)
                                                Text("로딩 중...")
                                                    .font(.pretendard.smallTextRegular)
                                                    .foregroundColor(.textSecondary)
                                            } else {
                                                Text("답글 더보기")
                                                    .font(.pretendard.smallTextRegular)
                                                    .foregroundColor(.textSecondary)
                                                Image(systemName: "chevron.down")
                                                    .font(.system(size: 10))
                                                    .foregroundColor(.textSecondary)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.05))
                                    .disabled(viewModel.loadingReplies.contains(comment.id))
                                }
                            }

                            Divider()
                        }
                        .onAppear {
                            let threshold = max(0, viewModel.comments.count - 3)
                            if index >= threshold {
                                Task {
                                    await viewModel.fetchComments(sortBy: viewModel.selectedSort, refresh: false)
                                }
                            }
                        }
                    }

                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
            }
        }
    }

    private func handleCommentLike(commentId: Int) {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        Task {
            await viewModel.toggleLike(commentId: commentId)
        }
    }

    private func handleCommentReport(comment: Comment) {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        viewModel.commentToReport = comment
        viewModel.showReportSheet = true
    }

    private func handleReply(to comment: Comment) {
        guard !authManager.requiresLogin else {
            showLoginPrompt = true
            return
        }

        viewModel.replyingTo = comment
    }

    private func handleEdit(comment: Comment) {
        viewModel.editingComment = comment
    }

    private func handleDelete(comment: Comment) {
        viewModel.commentToDelete = comment
        viewModel.showDeleteConfirmation = true
    }
}

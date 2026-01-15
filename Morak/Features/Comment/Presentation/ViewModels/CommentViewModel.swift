//
//  CommentViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation
import SwiftUI

@MainActor
final class CommentViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var comments: [Comment] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showTokenExpiredAlert: Bool = false
    @Published var selectedSort: CommentSortOption = .latest

    // 대댓글 관리 (commentId: [replies])
    @Published var repliesMap: [Int: [Comment]] = [:]
    @Published var expandedComments: Set<Int> = []
    @Published var loadingReplies: Set<Int> = []
    @Published var repliesHasMore: [Int: Bool] = [:]  // [parentId: hasMore]

    // 답글 작성 모드
    @Published var replyingTo: Comment?  // 현재 답글 작성 중인 댓글

    // 수정 모드
    @Published var editingComment: Comment?  // 현재 수정 중인 댓글

    // 삭제 확인
    @Published var showDeleteConfirmation: Bool = false
    @Published var commentToDelete: Comment?

    // 신고
    @Published var showReportSheet: Bool = false
    @Published var commentToReport: Comment?
    @Published var showReportSuccessAlert: Bool = false
    @Published var reportSuccessMessage: String = ""

    // 차단
    @Published var showBlockConfirmation: Bool = false
    @Published var commentToBlock: Comment?
    @Published var showBlockSuccessAlert: Bool = false

    // MARK: - Private Properties
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    private let getCommentsUseCase: GetCommentsUseCaseProtocol
    private let getRepliesUseCase: GetRepliesUseCaseProtocol
    private let createCommentUseCase: CreateCommentUseCaseProtocol
    private let updateCommentUseCase: UpdateCommentUseCaseProtocol
    private let deleteCommentUseCase: DeleteCommentUseCaseProtocol
    private let likeCommentUseCase: LikeCommentUseCaseProtocol
    private let reportCommentUseCase: ReportCommentUseCaseProtocol
    private let blockUserUseCase: BlockUserUseCaseProtocol
    private let pageSize: Int = 10
    private let replyPageSize: Int = 5
    private let postId: Int

    // 대댓글 페이징 관리
    private var replyPages: [Int: Int] = [:]  // [parentId: currentPage]

    init(
        postId: Int,
        getCommentsUseCase: GetCommentsUseCaseProtocol,
        getRepliesUseCase: GetRepliesUseCaseProtocol,
        createCommentUseCase: CreateCommentUseCaseProtocol,
        updateCommentUseCase: UpdateCommentUseCaseProtocol,
        deleteCommentUseCase: DeleteCommentUseCaseProtocol,
        likeCommentUseCase: LikeCommentUseCaseProtocol,
        reportCommentUseCase: ReportCommentUseCaseProtocol,
        blockUserUseCase: BlockUserUseCaseProtocol
    ) {
        self.postId = postId
        self.getCommentsUseCase = getCommentsUseCase
        self.getRepliesUseCase = getRepliesUseCase
        self.createCommentUseCase = createCommentUseCase
        self.updateCommentUseCase = updateCommentUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
        self.likeCommentUseCase = likeCommentUseCase
        self.reportCommentUseCase = reportCommentUseCase
        self.blockUserUseCase = blockUserUseCase
    }

    // MARK: - Public Methods

    func fetchComments(sortBy: CommentSortOption, refresh: Bool = false) async {
        guard !isLoading else { return }

        if refresh {
            currentPage = 1
            hasMorePages = true
            comments = []
        }

        guard hasMorePages else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await getCommentsUseCase.execute(
                postId: postId,
                page: currentPage,
                size: pageSize,
                sortBy: sortBy.apiValue
            )

            if refresh {
                comments = response.content
            } else {
                comments.append(contentsOf: response.content)
            }

            currentPage += 1
            hasMorePages = !response.last

        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }

        isLoading = false
    }

    func toggleLike(commentId: Int) async {
        do {
            let serverResponse = try await likeCommentUseCase.execute(commentId: commentId)

            // 루트 댓글에서 찾기
            if let index = comments.firstIndex(where: { $0.id == commentId }) {
                comments[index].updateLikeState(serverResponse: serverResponse)
            }
            // 대댓글에서 찾기
            else {
                for (parentId, var replies) in repliesMap {
                    if let replyIndex = replies.firstIndex(where: { $0.id == commentId }) {
                        replies[replyIndex].updateLikeState(serverResponse: serverResponse)
                        repliesMap[parentId] = replies
                        break
                    }
                }
            }

            if serverResponse == nil {
                errorMessage = "좋아요 처리 중 오류가 발생했습니다."
            }
        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }
    }

    func changeSort(_ sort: CommentSortOption) {
        selectedSort = sort
        Task {
            await fetchComments(sortBy: sort, refresh: true)
        }
    }

    func toggleReplies(for commentId: Int) {
        if expandedComments.contains(commentId) {
            // 접기
            expandedComments.remove(commentId)
        } else {
            // 펼치기
            expandedComments.insert(commentId)
            // 대댓글이 아직 로드되지 않았다면 로드
            if repliesMap[commentId] == nil {
                Task {
                    await loadReplies(for: commentId)
                }
            }
        }
    }

    // 대댓글 로드
    func loadReplies(for parentId: Int, loadMore: Bool = false) async {
        guard !loadingReplies.contains(parentId) else { return }
        loadingReplies.insert(parentId)

        do {
            // 페이지 초기화 또는 다음 페이지
            let currentPage = replyPages[parentId] ?? 1

            let response = try await getRepliesUseCase.execute(
                parentId: parentId,
                page: currentPage,
                size: replyPageSize
            )

            if loadMore {
                // 더보기: 기존 대댓글에 추가
                var existingReplies = repliesMap[parentId] ?? []
                existingReplies.append(contentsOf: response.content)
                repliesMap[parentId] = existingReplies
            } else {
                // 첫 로드
                repliesMap[parentId] = response.content
            }

            // 다음 페이지 및 hasMore 저장
            repliesHasMore[parentId] = !response.last
            if !response.last {
                replyPages[parentId] = currentPage + 1
            }

        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "대댓글을 불러오는 중 오류가 발생했습니다."
        }

        loadingReplies.remove(parentId)
    }

    func createComment(content: String, parentId: Int?) async -> Bool {
        do {
            let newComment = try await createCommentUseCase.execute(
                postId: postId,
                content: content,
                parentId: parentId
            )

            if let parentId = parentId {
                // 대댓글인 경우: 서버에서 전체 답글 목록 다시 로드
                // 페이지 초기화
                replyPages[parentId] = 1

                // 답글 목록 새로고침
                await loadReplies(for: parentId, loadMore: false)

                // 자동으로 펼치기
                expandedComments.insert(parentId)

                // 부모 댓글의 hasChildren 업데이트 (필요시)
                // Comment 구조체가 let이므로 서버에서 다시 가져와야 정확함
            } else {
                // 일반 댓글인 경우: comments 맨 앞에 추가
                comments.insert(newComment, at: 0)
            }

            return true

        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
            return false
        } catch {
            errorMessage = "댓글 작성 중 오류가 발생했습니다."
            return false
        }
    }

    func updateComment(commentId: Int, content: String, parentId: Int?) async -> Bool {
        do {
            let updatedComment = try await updateCommentUseCase.execute(
                commentId: commentId,
                content: content
            )

            if let parentId = parentId {
                // 대댓글인 경우: repliesMap에서 해당 댓글 업데이트
                if var replies = repliesMap[parentId],
                   let index = replies.firstIndex(where: { $0.id == commentId }) {
                    replies[index] = updatedComment
                    repliesMap[parentId] = replies
                }
            } else {
                // 루트 댓글인 경우: comments에서 해당 댓글 업데이트
                if let index = comments.firstIndex(where: { $0.id == commentId }) {
                    comments[index] = updatedComment
                }
            }

            return true

        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
            return false
        } catch {
            errorMessage = "댓글 수정 중 오류가 발생했습니다."
            return false
        }
    }

    func deleteComment(commentId: Int, parentId: Int?) async -> Bool {
        do {
            try await deleteCommentUseCase.execute(commentId: commentId)

            if let parentId = parentId {
                // 대댓글인 경우: repliesMap에서 해당 댓글 제거
                if var replies = repliesMap[parentId] {
                    replies.removeAll { $0.id == commentId }
                    repliesMap[parentId] = replies
                }
            } else {
                // 루트 댓글인 경우: comments에서 해당 댓글 제거
                comments.removeAll { $0.id == commentId }
            }

            return true

        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
            return false
        } catch {
            errorMessage = "댓글 삭제 중 오류가 발생했습니다."
            return false
        }
    }

    var totalComments: Int {
        return comments.count
    }

    func reportComment(commentId: Int, reason: String) async {
        do {
            let message = try await reportCommentUseCase.execute(commentId: commentId, reason: reason)
            reportSuccessMessage = message
            showReportSuccessAlert = true
            commentToReport = nil

        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "신고 처리 중 오류가 발생했습니다."
        }
    }

    func blockUser() async {
        guard let comment = commentToBlock else { return }

        do {
            _ = try await blockUserUseCase.execute(userId: comment.userId)
            showBlockSuccessAlert = true
            commentToBlock = nil

            // 차단 성공 후 댓글 목록 새로고침 (차단된 사용자 댓글 제외)
            await fetchComments(sortBy: selectedSort, refresh: true)

        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "차단 처리 중 오류가 발생했습니다."
        }
    }
}

// MARK: - Factory
extension CommentViewModel {
    static func makeDefault(postId: Int) -> CommentViewModel {
        let getCommentsUseCase = GetCommentsUseCase.makeDefault()
        let getRepliesUseCase = GetRepliesUseCase.makeDefault()
        let createCommentUseCase = CreateCommentUseCase.makeDefault()
        let updateCommentUseCase = UpdateCommentUseCase.makeDefault()
        let deleteCommentUseCase = DeleteCommentUseCase.makeDefault()
        let likeCommentUseCase = LikeCommentUseCase.makeDefault()
        let reportCommentUseCase = ReportCommentUseCase.makeDefault()
        let blockUserUseCase = BlockUserUseCase.makeDefault()
        return CommentViewModel(
            postId: postId,
            getCommentsUseCase: getCommentsUseCase,
            getRepliesUseCase: getRepliesUseCase,
            createCommentUseCase: createCommentUseCase,
            updateCommentUseCase: updateCommentUseCase,
            deleteCommentUseCase: deleteCommentUseCase,
            likeCommentUseCase: likeCommentUseCase,
            reportCommentUseCase: reportCommentUseCase,
            blockUserUseCase: blockUserUseCase
        )
    }
}

//
//  PostDetailViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation
import SwiftUI

@MainActor
final class PostDetailViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var post: Post?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showTokenExpiredAlert: Bool = false
    @Published var isDeleted: Bool = false

    // MARK: - Private Properties
    private let getPostDetailUseCase: GetPostDetailUseCaseProtocol
    private let likePostUseCase: LikePostUseCaseProtocol
    private let deletePostUseCase: DeletePostUseCaseProtocol
    private let postId: Int

    // MARK: - Computed Properties
    var isMyPost: Bool {
        return post?.wroteByLoginUser ?? false
    }

    init(
        postId: Int,
        getPostDetailUseCase: GetPostDetailUseCaseProtocol,
        likePostUseCase: LikePostUseCaseProtocol,
        deletePostUseCase: DeletePostUseCaseProtocol
    ) {
        self.postId = postId
        self.getPostDetailUseCase = getPostDetailUseCase
        self.likePostUseCase = likePostUseCase
        self.deletePostUseCase = deletePostUseCase
    }

    // MARK: - Public Methods

    func fetchPostDetail() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let fetchedPost = try await getPostDetailUseCase.execute(postId: postId)
            post = fetchedPost

        } catch let error as NetworkError {
            // 토큰 만료 (장기 미접속) 에러는 별도 처리
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

    func toggleLike() async {
        guard let currentPost = post else { return }

        do {
            let serverResponse = try await likePostUseCase.execute(postId: currentPost.id)

            if var updatedPost = post {
                updatedPost.updateLikeState(serverResponse: serverResponse)
                post = updatedPost
            }

            if serverResponse == nil {
                errorMessage = "좋아요 처리 중 오류가 발생했습니다."
            }
        } catch let error as NetworkError {
            // 토큰 만료 에러는 별도 처리
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }
    }

    func deletePost() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            try await deletePostUseCase.execute(postId: postId)
            isDeleted = true

        } catch let error as NetworkError {
            // 토큰 만료 에러는 별도 처리
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
}

// MARK: - Factory
extension PostDetailViewModel {
    static func makeDefault(postId: Int) -> PostDetailViewModel {
        let getPostDetailUseCase = GetPostDetailUseCase.makeDefault()
        let likePostUseCase = LikePostUseCase.makeDefault()
        let deletePostUseCase = DeletePostUseCase.makeDefault()
        return PostDetailViewModel(
            postId: postId,
            getPostDetailUseCase: getPostDetailUseCase,
            likePostUseCase: likePostUseCase,
            deletePostUseCase: deletePostUseCase
        )
    }
}

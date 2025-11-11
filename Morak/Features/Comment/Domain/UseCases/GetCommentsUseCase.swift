//
//  GetCommentsUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

protocol GetCommentsUseCaseProtocol {
    func execute(postId: Int, page: Int, size: Int, sortBy: String) async throws -> CommentListResponse
}

final class GetCommentsUseCase: GetCommentsUseCaseProtocol {
    private let repository: CommentRepositoryProtocol

    init(repository: CommentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: Int, page: Int, size: Int, sortBy: String) async throws -> CommentListResponse {
        let response = try await repository.getCommentList(postId: postId, page: page, size: size, sortBy: sortBy)

        return response
    }
}

// MARK: - Factory
extension GetCommentsUseCase {
    static func makeDefault() -> GetCommentsUseCase {
        let repository = CommentRepository()
        return GetCommentsUseCase(repository: repository)
    }
}

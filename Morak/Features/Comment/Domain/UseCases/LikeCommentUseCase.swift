//
//  LikeCommentUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

protocol LikeCommentUseCaseProtocol {
    func execute(commentId: Int) async throws -> Bool?
}

final class LikeCommentUseCase: LikeCommentUseCaseProtocol {
    private let repository: CommentRepositoryProtocol

    init(repository: CommentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(commentId: Int) async throws -> Bool? {
        let result = try await repository.likeComment(commentId: commentId)

        return result
    }
}

// MARK: - Factory
extension LikeCommentUseCase {
    static func makeDefault() -> LikeCommentUseCase {
        let repository = CommentRepository()
        return LikeCommentUseCase(repository: repository)
    }
}

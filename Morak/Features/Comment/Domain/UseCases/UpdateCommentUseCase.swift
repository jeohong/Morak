//
//  UpdateCommentUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/25/25.
//

import Foundation

protocol UpdateCommentUseCaseProtocol {
    func execute(commentId: Int, content: String) async throws -> Comment
}

final class UpdateCommentUseCase: UpdateCommentUseCaseProtocol {
    private let repository: CommentRepositoryProtocol

    init(repository: CommentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(commentId: Int, content: String) async throws -> Comment {
        let comment = try await repository.updateComment(commentId: commentId, content: content)

        return comment
    }
}

// MARK: - Factory
extension UpdateCommentUseCase {
    static func makeDefault() -> UpdateCommentUseCase {
        let repository = CommentRepository()
        return UpdateCommentUseCase(repository: repository)
    }
}

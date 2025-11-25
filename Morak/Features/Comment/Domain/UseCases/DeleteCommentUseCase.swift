//
//  DeleteCommentUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/25/25.
//

import Foundation

protocol DeleteCommentUseCaseProtocol {
    func execute(commentId: Int) async throws
}

final class DeleteCommentUseCase: DeleteCommentUseCaseProtocol {
    private let repository: CommentRepositoryProtocol

    init(repository: CommentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(commentId: Int) async throws {
        try await repository.deleteComment(commentId: commentId)
    }
}

// MARK: - Factory
extension DeleteCommentUseCase {
    static func makeDefault() -> DeleteCommentUseCase {
        let repository = CommentRepository()
        return DeleteCommentUseCase(repository: repository)
    }
}

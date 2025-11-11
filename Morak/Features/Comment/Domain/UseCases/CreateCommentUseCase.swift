//
//  CreateCommentUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

protocol CreateCommentUseCaseProtocol {
    func execute(postId: Int, content: String, parentId: Int?) async throws -> Comment
}

final class CreateCommentUseCase: CreateCommentUseCaseProtocol {
    private let repository: CommentRepositoryProtocol

    init(repository: CommentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: Int, content: String, parentId: Int?) async throws -> Comment {
        let comment = try await repository.createComment(postId: postId, content: content, parentId: parentId)

        return comment
    }
}

// MARK: - Factory
extension CreateCommentUseCase {
    static func makeDefault() -> CreateCommentUseCase {
        let repository = CommentRepository()
        return CreateCommentUseCase(repository: repository)
    }
}

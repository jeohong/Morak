//
//  ReportCommentUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

protocol ReportCommentUseCaseProtocol {
    func execute(commentId: Int, reason: String) async throws -> String
}

final class ReportCommentUseCase: ReportCommentUseCaseProtocol {
    private let repository: CommentRepositoryProtocol

    init(repository: CommentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(commentId: Int, reason: String) async throws -> String {
        return try await repository.reportComment(commentId: commentId, reason: reason)
    }
}

// MARK: - Factory
extension ReportCommentUseCase {
    static func makeDefault() -> ReportCommentUseCase {
        let repository = CommentRepository()
        return ReportCommentUseCase(repository: repository)
    }
}

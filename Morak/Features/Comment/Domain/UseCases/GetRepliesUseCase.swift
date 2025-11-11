//
//  GetRepliesUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

protocol GetRepliesUseCaseProtocol {
    func execute(parentId: Int, page: Int, size: Int) async throws -> CommentListResponse
}

final class GetRepliesUseCase: GetRepliesUseCaseProtocol {
    private let repository: CommentRepositoryProtocol

    init(repository: CommentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(parentId: Int, page: Int, size: Int) async throws -> CommentListResponse {
        let response = try await repository.getReplies(parentId: parentId, page: page, size: size)

        return response
    }
}

// MARK: - Factory
extension GetRepliesUseCase {
    static func makeDefault() -> GetRepliesUseCase {
        let repository = CommentRepository()
        return GetRepliesUseCase(repository: repository)
    }
}

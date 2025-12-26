//
//  ReportPostUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

protocol ReportPostUseCaseProtocol {
    func execute(postId: Int, reason: String) async throws -> String
}

final class ReportPostUseCase: ReportPostUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: Int, reason: String) async throws -> String {
        return try await repository.reportPost(postId: postId, reason: reason)
    }
}

// MARK: - Factory
extension ReportPostUseCase {
    static func makeDefault() -> ReportPostUseCase {
        let repository = PostRepository()
        return ReportPostUseCase(repository: repository)
    }
}

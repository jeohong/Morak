//
//  UpdatePostUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/21/25.
//

import Foundation

protocol UpdatePostUseCaseProtocol {
    func execute(postId: Int, content: String) async throws -> Post
}

final class UpdatePostUseCase: UpdatePostUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: Int, content: String) async throws -> Post {
        return try await repository.updatePost(postId: postId, content: content)
    }
}

// MARK: - Factory
extension UpdatePostUseCase {
    static func makeDefault() -> UpdatePostUseCase {
        let repository = PostRepository()
        return UpdatePostUseCase(repository: repository)
    }
}

//
//  LikePostUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/5/25.
//

import Foundation

protocol LikePostUseCaseProtocol {
    func execute(postId: Int) async throws -> Bool?
}

final class LikePostUseCase: LikePostUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: Int) async throws -> Bool? {
        return try await repository.likePost(postId: postId)
    }
}

// MARK: - Factory
extension LikePostUseCase {
    static func makeDefault() -> LikePostUseCase {
        let repository = PostRepository()
        return LikePostUseCase(repository: repository)
    }
}

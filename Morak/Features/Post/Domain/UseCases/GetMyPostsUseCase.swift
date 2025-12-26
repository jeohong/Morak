//
//  GetMyPostsUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

protocol GetMyPostsUseCaseProtocol {
    func execute(page: Int, size: Int, sortBy: String) async throws -> PostListResponse
}

final class GetMyPostsUseCase: GetMyPostsUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int, size: Int, sortBy: String) async throws -> PostListResponse {
        let response = try await repository.getMyPosts(page: page, size: size, sortBy: sortBy)

        return response
    }
}

// MARK: - Factory
extension GetMyPostsUseCase {
    static func makeDefault() -> GetMyPostsUseCase {
        let repository = PostRepository()
        return GetMyPostsUseCase(repository: repository)
    }
}

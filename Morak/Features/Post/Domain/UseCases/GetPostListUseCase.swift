//
//  GetPostListUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/4/25.
//

import Foundation

protocol GetPostListUseCaseProtocol {
    func execute(page: Int, size: Int, sortBy: String) async throws -> PostListResponse
}

final class GetPostListUseCase: GetPostListUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute(page: Int, size: Int, sortBy: String) async throws -> PostListResponse {
        let response = try await repository.getPostList(page: page, size: size, sortBy: sortBy)
        
        return response
    }
}

// MARK: - Factory
extension GetPostListUseCase {
    static func makeDefault() -> GetPostListUseCase {
        let repository = PostRepository()
        return GetPostListUseCase(repository: repository)
    }
}

//
//  GetPostDetailUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

protocol GetPostDetailUseCaseProtocol {
    func execute(postId: Int) async throws -> Post
}

final class GetPostDetailUseCase: GetPostDetailUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute(postId: Int) async throws -> Post {
        let post = try await repository.getPostDetail(postId: postId)

        return post
    }
}

// MARK: - Factory
extension GetPostDetailUseCase {
    static func makeDefault() -> GetPostDetailUseCase {
        let repository = PostRepository()
        return GetPostDetailUseCase(repository: repository)
    }
}

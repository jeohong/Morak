//
//  CreatePostUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 11/7/25.
//

import Foundation

protocol CreatePostUseCaseProtocol {
    func execute(content: String) async throws -> Post
}

final class CreatePostUseCase: CreatePostUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute(content: String) async throws -> Post {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw PostError.emptyContent
        }

        return try await repository.createPost(content: content)
    }
}

// MARK: - Factory
extension CreatePostUseCase {
    static func makeDefault() -> CreatePostUseCase {
        let repository = PostRepository()
        return CreatePostUseCase(repository: repository)
    }
}

// MARK: - Error
enum PostError: LocalizedError {
    case emptyContent

    var errorDescription: String? {
        switch self {
        case .emptyContent:
            return "내용을 입력해주세요."
        }
    }
}

//
//  SearchUsersUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

protocol SearchUsersUseCaseProtocol {
    func execute(nickname: String) async throws -> [Friend]
}

final class SearchUsersUseCase: SearchUsersUseCaseProtocol {
    private let repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol = UserRepository()) {
        self.repository = repository
    }

    func execute(nickname: String) async throws -> [Friend] {
        return try await repository.searchUsers(nickname: nickname)
    }
}

// MARK: - Factory
extension SearchUsersUseCase {
    static func makeDefault() -> SearchUsersUseCase {
        return SearchUsersUseCase(repository: UserRepository())
    }
}

//
//  GetFriendsUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

protocol GetFriendsUseCaseProtocol {
    func execute() async throws -> [Friend]
}

final class GetFriendsUseCase: GetFriendsUseCaseProtocol {
    private let repository: FriendRepositoryProtocol

    init(repository: FriendRepositoryProtocol = FriendRepository()) {
        self.repository = repository
    }

    func execute() async throws -> [Friend] {
        return try await repository.getFriends()
    }
}

// MARK: - Factory
extension GetFriendsUseCase {
    static func makeDefault() -> GetFriendsUseCase {
        return GetFriendsUseCase(repository: FriendRepository())
    }
}

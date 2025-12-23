//
//  DeleteFriendUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

protocol DeleteFriendUseCaseProtocol {
    func execute(friendId: Int) async throws
}

final class DeleteFriendUseCase: DeleteFriendUseCaseProtocol {
    private let repository: FriendRepositoryProtocol

    init(repository: FriendRepositoryProtocol = FriendRepository()) {
        self.repository = repository
    }

    func execute(friendId: Int) async throws {
        try await repository.deleteFriend(friendId: friendId)
    }
}

// MARK: - Factory
extension DeleteFriendUseCase {
    static func makeDefault() -> DeleteFriendUseCase {
        return DeleteFriendUseCase(repository: FriendRepository())
    }
}

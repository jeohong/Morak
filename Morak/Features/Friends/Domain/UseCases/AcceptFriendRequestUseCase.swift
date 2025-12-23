//
//  AcceptFriendRequestUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

protocol AcceptFriendRequestUseCaseProtocol {
    func execute(requestId: Int) async throws
}

final class AcceptFriendRequestUseCase: AcceptFriendRequestUseCaseProtocol {
    private let repository: FriendRepositoryProtocol

    init(repository: FriendRepositoryProtocol = FriendRepository()) {
        self.repository = repository
    }

    func execute(requestId: Int) async throws {
        try await repository.acceptRequest(requestId: requestId)
    }
}

// MARK: - Factory
extension AcceptFriendRequestUseCase {
    static func makeDefault() -> AcceptFriendRequestUseCase {
        return AcceptFriendRequestUseCase(repository: FriendRepository())
    }
}

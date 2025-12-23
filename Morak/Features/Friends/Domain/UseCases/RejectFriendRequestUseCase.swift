//
//  RejectFriendRequestUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

protocol RejectFriendRequestUseCaseProtocol {
    func execute(requestId: Int) async throws
}

final class RejectFriendRequestUseCase: RejectFriendRequestUseCaseProtocol {
    private let repository: FriendRepositoryProtocol

    init(repository: FriendRepositoryProtocol = FriendRepository()) {
        self.repository = repository
    }

    func execute(requestId: Int) async throws {
        try await repository.rejectRequest(requestId: requestId)
    }
}

// MARK: - Factory
extension RejectFriendRequestUseCase {
    static func makeDefault() -> RejectFriendRequestUseCase {
        return RejectFriendRequestUseCase(repository: FriendRepository())
    }
}

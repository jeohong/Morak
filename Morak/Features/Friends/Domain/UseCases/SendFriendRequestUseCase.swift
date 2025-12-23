//
//  SendFriendRequestUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

protocol SendFriendRequestUseCaseProtocol {
    func execute(receiverId: Int) async throws
}

final class SendFriendRequestUseCase: SendFriendRequestUseCaseProtocol {
    private let repository: FriendRepositoryProtocol

    init(repository: FriendRepositoryProtocol = FriendRepository()) {
        self.repository = repository
    }

    func execute(receiverId: Int) async throws {
        try await repository.sendRequest(receiverId: receiverId)
    }
}

// MARK: - Factory
extension SendFriendRequestUseCase {
    static func makeDefault() -> SendFriendRequestUseCase {
        return SendFriendRequestUseCase(repository: FriendRepository())
    }
}

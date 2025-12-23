//
//  GetFriendRequestsUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

protocol GetFriendRequestsUseCaseProtocol {
    func execute() async throws -> [FriendRequest]
}

final class GetFriendRequestsUseCase: GetFriendRequestsUseCaseProtocol {
    private let repository: FriendRepositoryProtocol

    init(repository: FriendRepositoryProtocol = FriendRepository()) {
        self.repository = repository
    }

    func execute() async throws -> [FriendRequest] {
        return try await repository.getReceivedRequests()
    }
}

// MARK: - Factory
extension GetFriendRequestsUseCase {
    static func makeDefault() -> GetFriendRequestsUseCase {
        return GetFriendRequestsUseCase(repository: FriendRepository())
    }
}

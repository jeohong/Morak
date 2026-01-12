//
//  BlockUserUseCase.swift
//  Morak
//
//  Created by 홍정민 on 1/12/26.
//

import Foundation

protocol BlockUserUseCaseProtocol {
    func execute(userId: Int) async throws -> String
}

final class BlockUserUseCase: BlockUserUseCaseProtocol {
    private let repository: BlockRepositoryProtocol

    init(repository: BlockRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: Int) async throws -> String {
        return try await repository.blockUser(userId: userId)
    }
}

// MARK: - Factory
extension BlockUserUseCase {
    static func makeDefault() -> BlockUserUseCase {
        let repository = BlockRepository()
        return BlockUserUseCase(repository: repository)
    }
}

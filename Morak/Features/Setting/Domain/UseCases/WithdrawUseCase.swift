//
//  WithdrawUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

protocol WithdrawUseCaseProtocol {
    func execute() async throws -> String
}

final class WithdrawUseCase: WithdrawUseCaseProtocol {
    private let repository: SettingRepositoryProtocol

    init(repository: SettingRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> String {
        return try await repository.withdraw()
    }
}

// MARK: - Factory
extension WithdrawUseCase {
    static func makeDefault() -> WithdrawUseCase {
        let repository = SettingRepository()
        return WithdrawUseCase(repository: repository)
    }
}

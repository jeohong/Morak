//
//  GetMyInfoUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

protocol GetMyInfoUseCaseProtocol {
    func execute() async throws -> MyInfo
}

final class GetMyInfoUseCase: GetMyInfoUseCaseProtocol {
    private let repository: SettingRepositoryProtocol

    init(repository: SettingRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> MyInfo {
        return try await repository.getMyInfo()
    }
}

// MARK: - Factory
extension GetMyInfoUseCase {
    static func makeDefault() -> GetMyInfoUseCase {
        let repository = SettingRepository()
        return GetMyInfoUseCase(repository: repository)
    }
}

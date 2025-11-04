//
//  LogoutUseCase.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation

protocol LogoutUseCaseProtocol {
    func execute() async throws
}

final class LogoutUseCase: LogoutUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }
    
    func execute() async throws {
        do {
            _ = try await repository.logout()
            await clearAllUserData()
        } catch {
            await clearAllUserData()
        }
    }

    private func clearAllUserData() async {
        await AuthManager.shared.logout()
    }
}

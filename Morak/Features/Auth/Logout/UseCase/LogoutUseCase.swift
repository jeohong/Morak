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
            // 서버에 로그아웃 요청
            let response = try await repository.logout()
            print("서버 로그아웃 성공: \(response.message)")
            
            // 모든 로컬 데이터 정리
            clearAllUserData()
            
            print("로그아웃 완료")
        } catch {
            // 서버 로그아웃 실패해도 로컬 데이터는 정리
            print("서버 로그아웃 실패, 로컬 데이터만 정리: \(error.localizedDescription)")
            clearAllUserData()
        }
    }
    
    private func clearAllUserData() {
        // 토큰 삭제 (키체인 + UUID)
        SecureTokenManager.shared.clearTokens()
        
        // 사용자 정보 삭제 (UserDefaults)
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "user_email")
        UserDefaults.standard.removeObject(forKey: "user_nickname")
        
        // UserDefaults 동기화
        UserDefaults.standard.synchronize()
    }
}

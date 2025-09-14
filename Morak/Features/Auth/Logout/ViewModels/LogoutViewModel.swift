//
//  LogoutViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation

@MainActor
final class LogoutViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isLogoutSuccessful: Bool = false
    
    private let logoutUseCase: LogoutUseCaseProtocol
    
    init(logoutUseCase: LogoutUseCaseProtocol = LogoutUseCase()) {
        self.logoutUseCase = logoutUseCase
    }
    
    func logout() async {
        isLoading = true
        errorMessage = ""
        showError = false
        
        do {
            try await logoutUseCase.execute()
            isLogoutSuccessful = true
            print("로그아웃 성공")
            
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
            showError = true
            print("로그아웃 에러: \(error.localizedDescription)")
        } catch {
            errorMessage = "로그아웃 중 오류가 발생했습니다."
            showError = true
            print("로그아웃 에러: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func clearError() {
        showError = false
        errorMessage = ""
    }
}
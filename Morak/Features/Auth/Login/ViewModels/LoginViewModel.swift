//
//  LoginViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var isLoginSuccessful: Bool = false
    
    private let loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    var isFormValid: Bool {
        !email.isEmpty && email.contains("@") && !password.isEmpty && password.count >= 6
    }
    
    func login() async {
        guard isFormValid else { return }

        isLoading = true
        errorMessage = ""
        showError = false

        do {
            let loginRequest = LoginRequest(email: email, password: password)
            let loginData = try await loginUseCase.execute(loginRequest)
            
            // 로그인 성공
            isLoginSuccessful = true
            print("로그인 성공: \(loginData.nickname)")
            
        } catch let error as ValidationError {
            errorMessage = error.localizedDescription
            showError = true
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
            showError = true
        } catch {
            errorMessage = "로그인 중 오류가 발생했습니다."
            showError = true
        }
        
        isLoading = false
    }
    
    func clearError() {
        showError = false
        errorMessage = ""
    }
}
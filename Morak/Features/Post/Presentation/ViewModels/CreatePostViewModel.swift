//
//  CreatePostViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 11/7/25.
//

import Foundation
import SwiftUI

@MainActor
final class CreatePostViewModel: ObservableObject {
    @Published var content: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isPostCreated: Bool = false
    @Published var showTokenExpiredAlert: Bool = false

    private let createPostUseCase: CreatePostUseCaseProtocol
    private let maxContentLength: Int = 500 // 글자 수 제한

    init(createPostUseCase: CreatePostUseCaseProtocol) {
        self.createPostUseCase = createPostUseCase
    }

    var canPost: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    var characterCount: Int {
        content.count
    }

    var isOverMaxLength: Bool {
        content.count > maxContentLength
    }

    func createPost() async {
        guard canPost else { return }
        guard !isOverMaxLength else {
            errorMessage = "글자 수 제한을 초과했습니다. (\(maxContentLength)자 이내)"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            _ = try await createPostUseCase.execute(content: content)
            isPostCreated = true
        } catch let error as PostError {
            errorMessage = error.localizedDescription
        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }

        isLoading = false
    }

    func resetContent() {
        content = ""
        errorMessage = nil
        isPostCreated = false
    }
}

// MARK: - Factory
extension CreatePostViewModel {
    static func makeDefault() -> CreatePostViewModel {
        let createPostUseCase = CreatePostUseCase.makeDefault()
        return CreatePostViewModel(createPostUseCase: createPostUseCase)
    }
}

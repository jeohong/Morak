//
//  EditPostViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 11/21/25.
//

import Foundation
import SwiftUI

@MainActor
final class EditPostViewModel: ObservableObject {
    @Published var content: String
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isPostUpdated: Bool = false
    @Published var showTokenExpiredAlert: Bool = false

    private let postId: Int
    private let updatePostUseCase: UpdatePostUseCaseProtocol
    private let maxContentLength: Int = 500

    init(postId: Int, initialContent: String, updatePostUseCase: UpdatePostUseCaseProtocol) {
        self.postId = postId
        self.content = initialContent
        self.updatePostUseCase = updatePostUseCase
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

    func updatePost() async {
        guard canPost else { return }
        guard !isOverMaxLength else {
            errorMessage = "글자 수 제한을 초과했습니다. (\(maxContentLength)자 이내)"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            _ = try await updatePostUseCase.execute(postId: postId, content: content)
            isPostUpdated = true
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
}

// MARK: - Factory
extension EditPostViewModel {
    static func makeDefault(postId: Int, initialContent: String) -> EditPostViewModel {
        let updatePostUseCase = UpdatePostUseCase.makeDefault()
        return EditPostViewModel(postId: postId, initialContent: initialContent, updatePostUseCase: updatePostUseCase)
    }
}

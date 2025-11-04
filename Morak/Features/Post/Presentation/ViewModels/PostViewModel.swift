//
//  PostViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 11/3/25.
//

import Foundation
import SwiftUI

@MainActor
final class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentPage: Int = 1
    @Published var hasMorePages: Bool = true

    private let getPostListUseCase: GetPostListUseCaseProtocol
    private let pageSize: Int = 10

    init(getPostListUseCase: GetPostListUseCaseProtocol) {
        self.getPostListUseCase = getPostListUseCase
    }

    func fetchPosts(sortBy: FilterOption, refresh: Bool = false) async {
        guard !isLoading else { return }

        if refresh {
            currentPage = 1
            hasMorePages = true
            posts = []
        }

        guard hasMorePages else { return }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await getPostListUseCase.execute(page: currentPage, size: pageSize, sortBy: sortBy.apiValue)
            
            if refresh {
                posts = response.content
            } else {
                posts.append(contentsOf: response.content)
            }
            
            currentPage += 1
            hasMorePages = !response.last

        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }

        isLoading = false
    }
}

// MARK: - Factory
extension PostViewModel {
    static func makeDefault() -> PostViewModel {
        let useCase = GetPostListUseCase.makeDefault()
        return PostViewModel(getPostListUseCase: useCase)
    }
}

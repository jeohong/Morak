//
//  MyPostsViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

@MainActor
final class MyPostsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showTokenExpiredAlert: Bool = false
    @Published var selectedFilter: FilterOption = .latest

    // MARK: - Private Properties
    private var currentPage: Int = 1
    private var hasMorePages: Bool = true
    private let getMyPostsUseCase: GetMyPostsUseCaseProtocol
    private let likePostUseCase: LikePostUseCaseProtocol
    private let pageSize: Int = 10
    private var hasInitialLoaded: Bool = false

    // MARK: - Init
    init(
        getMyPostsUseCase: GetMyPostsUseCaseProtocol,
        likePostUseCase: LikePostUseCaseProtocol
    ) {
        self.getMyPostsUseCase = getMyPostsUseCase
        self.likePostUseCase = likePostUseCase
    }

    // MARK: - Public Methods

    /// 내 게시물 목록 가져오기
    func fetchMyPosts(sortBy: FilterOption, refresh: Bool = false) async {
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
            let response = try await getMyPostsUseCase.execute(
                page: currentPage,
                size: pageSize,
                sortBy: sortBy.apiValue
            )

            if refresh {
                posts = response.content
            } else {
                posts.append(contentsOf: response.content)
            }

            currentPage += 1
            hasMorePages = !response.last

        } catch let error as NetworkError {
            switch error {
            case .tokenRefreshFailed:
                showTokenExpiredAlert = true
            case .cancelled:
                break
            default:
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }

        isLoading = false
    }

    /// 좋아요 토글
    func toggleLike(postId: Int) async {
        do {
            let serverResponse = try await likePostUseCase.execute(postId: postId)

            if let index = posts.firstIndex(where: { $0.id == postId }) {
                posts[index].updateLikeState(serverResponse: serverResponse)
            }

            if serverResponse == nil {
                errorMessage = "좋아요 처리 중 오류가 발생했습니다."
            }
        } catch let error as NetworkError {
            if case .tokenRefreshFailed = error {
                showTokenExpiredAlert = true
            } else {
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "알 수 없는 오류가 발생했습니다."
        }
    }

    /// 초기 로드 (최초 한 번만 실행)
    func loadInitialDataIfNeeded() {
        guard !hasInitialLoaded else { return }
        hasInitialLoaded = true

        Task {
            await fetchMyPosts(sortBy: selectedFilter)
        }
    }

    /// 필터 변경
    func changeFilter(_ filter: FilterOption) {
        selectedFilter = filter
        Task {
            await fetchMyPosts(sortBy: filter, refresh: true)
        }
    }

    /// 특정 포스트 업데이트
    func updatePost(_ updatedPost: Post) {
        if let index = posts.firstIndex(where: { $0.id == updatedPost.id }) {
            posts[index] = updatedPost
        }
    }

    /// 삭제된 포스트 제거
    func removePost(_ deletedPostId: Int) {
        posts.removeAll(where: { $0.id == deletedPostId })
    }
}

// MARK: - Factory
extension MyPostsViewModel {
    static func makeDefault() -> MyPostsViewModel {
        let getMyPostsUseCase = GetMyPostsUseCase.makeDefault()
        let likePostUseCase = LikePostUseCase.makeDefault()
        return MyPostsViewModel(
            getMyPostsUseCase: getMyPostsUseCase,
            likePostUseCase: likePostUseCase
        )
    }
}

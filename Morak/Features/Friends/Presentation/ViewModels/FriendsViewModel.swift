//
//  FriendsViewModel.swift
//  Morak
//
//  Created by Hong jeongmin on 11/27/25.
//

import Foundation

@MainActor
final class FriendsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedTab: FriendsTab = .search
    @Published var searchText: String = ""
    @Published var friends: [Friend] = []
    @Published var friendRequests: [FriendRequest] = []
    @Published var searchResults: [Friend] = []
    @Published var isLoading: Bool = false
    @Published var requestBadgeCount: Int = 0
    @Published var errorMessage: String?

    // 차단
    @Published var showBlockConfirmation: Bool = false
    @Published var userToBlock: Friend?
    @Published var showBlockSuccessAlert: Bool = false

    // MARK: - Private Properties
    private let searchUsersUseCase: SearchUsersUseCaseProtocol
    private let getFriendsUseCase: GetFriendsUseCaseProtocol
    private let getFriendRequestsUseCase: GetFriendRequestsUseCaseProtocol
    private let acceptFriendRequestUseCase: AcceptFriendRequestUseCaseProtocol
    private let rejectFriendRequestUseCase: RejectFriendRequestUseCaseProtocol
    private let sendFriendRequestUseCase: SendFriendRequestUseCaseProtocol
    private let deleteFriendUseCase: DeleteFriendUseCaseProtocol
    private let blockUserUseCase: BlockUserUseCaseProtocol

    // MARK: - Initialization
    init(
        searchUsersUseCase: SearchUsersUseCaseProtocol = SearchUsersUseCase.makeDefault(),
        getFriendsUseCase: GetFriendsUseCaseProtocol = GetFriendsUseCase.makeDefault(),
        getFriendRequestsUseCase: GetFriendRequestsUseCaseProtocol = GetFriendRequestsUseCase.makeDefault(),
        acceptFriendRequestUseCase: AcceptFriendRequestUseCaseProtocol = AcceptFriendRequestUseCase.makeDefault(),
        rejectFriendRequestUseCase: RejectFriendRequestUseCaseProtocol = RejectFriendRequestUseCase.makeDefault(),
        sendFriendRequestUseCase: SendFriendRequestUseCaseProtocol = SendFriendRequestUseCase.makeDefault(),
        deleteFriendUseCase: DeleteFriendUseCaseProtocol = DeleteFriendUseCase.makeDefault(),
        blockUserUseCase: BlockUserUseCaseProtocol = BlockUserUseCase.makeDefault()
    ) {
        self.searchUsersUseCase = searchUsersUseCase
        self.getFriendsUseCase = getFriendsUseCase
        self.getFriendRequestsUseCase = getFriendRequestsUseCase
        self.acceptFriendRequestUseCase = acceptFriendRequestUseCase
        self.rejectFriendRequestUseCase = rejectFriendRequestUseCase
        self.sendFriendRequestUseCase = sendFriendRequestUseCase
        self.deleteFriendUseCase = deleteFriendUseCase
        self.blockUserUseCase = blockUserUseCase
    }

    // MARK: - Actions
    func fetchFriends() async {
        // 로그인 안 한 상태면 API 호출 안 함
        guard !AuthManager.shared.requiresLogin else { return }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await getFriendsUseCase.execute()
            friends = result
        } catch {
            errorMessage = "친구 목록을 불러오는데 실패했습니다."
        }

        isLoading = false
    }

    func fetchFriendRequests() async {
        // 로그인 안 한 상태면 API 호출 안 함
        guard !AuthManager.shared.requiresLogin else { return }

        do {
            let result = try await getFriendRequestsUseCase.execute()
            friendRequests = result
            requestBadgeCount = result.count
        } catch {
            errorMessage = "친구 요청 목록을 불러오는데 실패했습니다."
        }
    }

    func searchFriends() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }

        Task {
            await performSearch()
        }
    }

    private func performSearch() async {
        isLoading = true
        errorMessage = nil

        do {
            let results = try await searchUsersUseCase.execute(nickname: searchText)
            searchResults = results
        } catch {
            errorMessage = "검색 중 오류가 발생했습니다."
            searchResults = []
        }

        isLoading = false
    }

    func acceptFriendRequest(_ request: FriendRequest) {
        Task {
            do {
                try await acceptFriendRequestUseCase.execute(requestId: request.id)
                friendRequests.removeAll { $0.id == request.id }
                requestBadgeCount = friendRequests.count
                // 친구 목록 새로고침
                await fetchFriends()
            } catch {
                errorMessage = "친구 요청 수락에 실패했습니다."
            }
        }
    }

    func rejectFriendRequest(_ request: FriendRequest) {
        Task {
            do {
                try await rejectFriendRequestUseCase.execute(requestId: request.id)
                friendRequests.removeAll { $0.id == request.id }
                requestBadgeCount = friendRequests.count
            } catch {
                errorMessage = "친구 요청 거절에 실패했습니다."
            }
        }
    }

    func deleteFriend(_ friend: Friend) {
        Task {
            do {
                try await deleteFriendUseCase.execute(friendId: friend.id)
                friends.removeAll { $0.id == friend.id }
            } catch {
                errorMessage = "친구 삭제에 실패했습니다."
            }
        }
    }

    func sendFriendRequest(to user: Friend) async -> Bool {
        do {
            try await sendFriendRequestUseCase.execute(receiverId: user.id)
            // 검색 결과에서 해당 유저 제거
            searchResults.removeAll { $0.id == user.id }
            return true
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
            return false
        } catch {
            errorMessage = "친구 요청 전송에 실패했습니다."
            return false
        }
    }

    func blockUser() async {
        guard let user = userToBlock else { return }

        do {
            _ = try await blockUserUseCase.execute(userId: user.id)
            // 검색 결과에서 해당 유저 제거
            searchResults.removeAll { $0.id == user.id }
            showBlockSuccessAlert = true
            userToBlock = nil
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "차단 처리 중 오류가 발생했습니다."
        }
    }

    func refreshData() async {
        await fetchFriends()
        await fetchFriendRequests()
    }

    func clearData() {
        friends = []
        friendRequests = []
        searchResults = []
        requestBadgeCount = 0
    }
}

//
//  FriendRepository.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

final class FriendRepository: FriendRepositoryProtocol {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }

    func getFriends() async throws -> [Friend] {
        let endpoint = FriendEndpoint.getFriends

        let apiResponse: BaseResponse<[FriendDTO]> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<[FriendDTO]>.self
        )

        let friends = apiResponse.data.map { dto in
            Friend(id: dto.friendId, nickname: dto.nickname)
        }

        return friends
    }

    func getReceivedRequests() async throws -> [FriendRequest] {
        let endpoint = FriendEndpoint.getReceivedRequests

        let apiResponse: BaseResponse<[FriendRequestDTO]> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<[FriendRequestDTO]>.self
        )

        let requests = apiResponse.data.map { dto in
            FriendRequest(
                id: dto.requestId,
                nickname: dto.senderNickname,
                requestedAt: dto.createdAt.toDate() ?? Date()
            )
        }

        return requests
    }

    func acceptRequest(requestId: Int) async throws {
        let endpoint = FriendEndpoint.acceptRequest(requestId: requestId)

        let _: BaseResponse<EmptyData> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<EmptyData>.self
        )
    }

    func rejectRequest(requestId: Int) async throws {
        let endpoint = FriendEndpoint.rejectRequest(requestId: requestId)

        let _: BaseResponse<EmptyData> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<EmptyData>.self
        )
    }

    func sendRequest(receiverId: Int) async throws {
        let endpoint = FriendEndpoint.sendRequest(receiverId: receiverId)

        let _: BaseResponse<EmptyData?> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<EmptyData?>.self
        )
    }

    func deleteFriend(friendId: Int) async throws {
        let endpoint = FriendEndpoint.deleteFriend(friendId: friendId)

        let _: BaseResponse<EmptyData> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<EmptyData>.self
        )
    }
}

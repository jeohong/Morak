//
//  FriendRepositoryProtocol.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

protocol FriendRepositoryProtocol {
    func getFriends() async throws -> [Friend]
    func getReceivedRequests() async throws -> [FriendRequest]
    func acceptRequest(requestId: Int) async throws
    func rejectRequest(requestId: Int) async throws
    func sendRequest(receiverId: Int) async throws
    func deleteFriend(friendId: Int) async throws
}

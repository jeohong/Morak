//
//  UserRepository.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

final class UserRepository: UserRepositoryProtocol {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }

    func searchUsers(nickname: String) async throws -> [Friend] {
        let endpoint = UserEndpoint.search(nickname: nickname)

        let apiResponse: BaseResponse<[UserSearchDTO]> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<[UserSearchDTO]>.self
        )

        let friends = apiResponse.data.map { dto in
            Friend(id: dto.id, nickname: dto.nickname)
        }

        return friends
    }
}

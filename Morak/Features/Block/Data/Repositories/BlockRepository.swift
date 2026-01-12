//
//  BlockRepository.swift
//  Morak
//
//  Created by 홍정민 on 1/12/26.
//

import Foundation

protocol BlockRepositoryProtocol {
    func blockUser(userId: Int) async throws -> String
}

final class BlockRepository: BlockRepositoryProtocol {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }

    func blockUser(userId: Int) async throws -> String {
        let endpoint = BlockEndpoint.blockUser(userId: userId)

        let apiResponse: BaseResponse<EmptyData> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<EmptyData>.self
        )

        return apiResponse.message
    }
}

//
//  SettingRepository.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

final class SettingRepository: SettingRepositoryProtocol {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }

    func getMyInfo() async throws -> MyInfo {
        let endpoint = UserEndpoint.getMyInfo

        let apiResponse: BaseResponse<MyInfoDTO> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<MyInfoDTO>.self
        )

        let domainMyInfo = MyInfoMapper.toDomain(apiResponse.data)

        return domainMyInfo
    }

    func withdraw() async throws -> String {
        let endpoint = UserEndpoint.withdrawal

        let apiResponse: BaseResponse<String> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<String>.self
        )

        return apiResponse.message
    }
}

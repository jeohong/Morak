//
//  PostRepository.swift
//  Morak
//
//  Created by Hong jeongmin on 11/3/25.
//

import Foundation

final class PostRepository: PostRepositoryProtocol {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }

    func getPostList(page: Int, size: Int, sortBy: String) async throws -> PostListResponse {
        let request = PostListRequest(page: page, size: size, sortBy: sortBy)
        let endpoint = PostEndpoint.getPostList(request)

        let apiResponse: BaseResponse<PostListResponseDTO> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<PostListResponseDTO>.self
        )

        let domainResponse = PostMapper.toDomain(apiResponse.data)

        return domainResponse
    }
}

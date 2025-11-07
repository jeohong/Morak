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

    func likePost(postId: Int) async throws -> Bool? {
        let endpoint = PostEndpoint.likePost(postId: postId)

        let apiResponse: LikeResponseDTO = try await apiManager.request(
            endpoint,
            responseType: LikeResponseDTO.self
        )

        return apiResponse.data
    }

    func createPost(content: String) async throws -> Post {
        let request = CreatePostRequest(content: content)
        let endpoint = PostEndpoint.createPost(request)

        let apiResponse: BaseResponse<PostDTO> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<PostDTO>.self
        )

        let domainPost = PostMapper.toDomain(apiResponse.data)

        return domainPost
    }
}

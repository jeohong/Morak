//
//  PostRepository.swift
//  Morak
//
//  Created by Hong jeongmin on 11/3/25.
//

import Foundation

protocol PostRepositoryProtocol {
    func getPostList(_ request: PostListRequest) async throws -> BaseResponse<PostListData>
}

final class PostRepository: PostRepositoryProtocol {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }

    func getPostList(_ request: PostListRequest) async throws -> BaseResponse<PostListData> {
        let endpoint = PostEndpoint.getPostList(request)
        return try await apiManager.request(endpoint, responseType: BaseResponse<PostListData>.self)
    }
}

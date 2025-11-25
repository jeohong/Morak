//
//  CommentRepository.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

final class CommentRepository: CommentRepositoryProtocol {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol = APIManager.shared) {
        self.apiManager = apiManager
    }

    func getCommentList(postId: Int, page: Int, size: Int, sortBy: String) async throws -> CommentListResponse {
        let request = CommentListRequest(postId: postId, page: page, size: size, sortBy: sortBy)
        let endpoint = CommentEndpoint.getCommentList(request)

        let apiResponse: BaseResponse<CommentListResponseDTO> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<CommentListResponseDTO>.self
        )

        let domainResponse = CommentMapper.toDomain(apiResponse.data)

        return domainResponse
    }

    func getReplies(parentId: Int, page: Int, size: Int) async throws -> CommentListResponse {
        let request = ReplyListRequest(parentId: parentId, page: page, size: size)
        let endpoint = CommentEndpoint.getReplies(request)

        let apiResponse: BaseResponse<CommentListResponseDTO> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<CommentListResponseDTO>.self
        )

        let domainResponse = CommentMapper.toDomain(apiResponse.data)

        return domainResponse
    }

    func createComment(postId: Int, content: String, parentId: Int?) async throws -> Comment {
        let request = CreateCommentRequest(postId: postId, content: content, parentId: parentId)
        let endpoint = CommentEndpoint.createComment(request)

        let apiResponse: BaseResponse<CommentDTO> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<CommentDTO>.self
        )

        let domainComment = CommentMapper.toDomain(apiResponse.data)

        return domainComment
    }

    func updateComment(commentId: Int, content: String) async throws -> Comment {
        let request = UpdateCommentRequest(content: content)
        let endpoint = CommentEndpoint.updateComment(commentId: commentId, request: request)

        let apiResponse: BaseResponse<CommentDTO> = try await apiManager.request(
            endpoint,
            responseType: BaseResponse<CommentDTO>.self
        )

        let domainComment = CommentMapper.toDomain(apiResponse.data)

        return domainComment
    }

    func likeComment(commentId: Int) async throws -> Bool? {
        let endpoint = CommentEndpoint.likeComment(commentId: commentId)

        let apiResponse: LikeResponseDTO = try await apiManager.request(
            endpoint,
            responseType: LikeResponseDTO.self
        )

        return apiResponse.data
    }
}

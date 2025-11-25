//
//  CommentRepositoryProtocol.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

protocol CommentRepositoryProtocol {
    func getCommentList(postId: Int, page: Int, size: Int, sortBy: String) async throws -> CommentListResponse
    func getReplies(parentId: Int, page: Int, size: Int) async throws -> CommentListResponse
    func createComment(postId: Int, content: String, parentId: Int?) async throws -> Comment
    func updateComment(commentId: Int, content: String) async throws -> Comment
    func deleteComment(commentId: Int) async throws
    func likeComment(commentId: Int) async throws -> Bool?
}

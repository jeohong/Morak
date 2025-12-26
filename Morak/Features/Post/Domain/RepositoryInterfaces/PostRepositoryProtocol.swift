//
//  PostRepositoryProtocol.swift
//  Morak
//
//  Created by Hong jeongmin on 11/4/25.
//

import Foundation

protocol PostRepositoryProtocol {
    func getPostList(page: Int, size: Int, sortBy: String) async throws -> PostListResponse
    func getPostDetail(postId: Int) async throws -> Post
    func likePost(postId: Int) async throws -> Bool?
    func createPost(content: String) async throws -> Post
    func updatePost(postId: Int, content: String) async throws -> Post
    func deletePost(postId: Int) async throws
    func reportPost(postId: Int, reason: String) async throws -> String
}

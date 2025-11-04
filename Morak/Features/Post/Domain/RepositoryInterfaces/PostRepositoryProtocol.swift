//
//  PostRepositoryProtocol.swift
//  Morak
//
//  Created by Hong jeongmin on 11/4/25.
//

import Foundation

protocol PostRepositoryProtocol {
    func getPostList(page: Int, size: Int, sortBy: String) async throws -> PostListResponse
}

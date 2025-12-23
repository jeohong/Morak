//
//  PostMapper.swift
//  Morak
//
//  Created by Hong jeongmin on 11/4/25.
//

import Foundation

// MARK: - DTO -> Entity Mapper
struct PostMapper {
    // PostDTO -> Post Entity
    static func toDomain(_ dto: PostDTO) -> Post {
        return Post(
            id: dto.id,
            nickname: dto.nickname,
            content: dto.content,
            likeCount: dto.likeCount,
            commentCount: dto.commentCount,
            viewCount: dto.viewCount,
            createdAt: dto.createdAt,
            modifiedAt: dto.modifiedAt,
            likedByLoginUser: dto.likedByLoginUser,
            wroteByLoginUser: dto.wroteByLoginUser
        )
    }

    // PostListResponseDTO -> Domain Model
    static func toDomain(_ dto: PostListResponseDTO) -> PostListResponse {
        return PostListResponse(
            content: dto.content.map { toDomain($0) },
            totalPages: dto.totalPages,
            totalElements: dto.totalElements,
            size: dto.size,
            number: dto.number,
            first: dto.first,
            last: dto.last
        )
    }
}

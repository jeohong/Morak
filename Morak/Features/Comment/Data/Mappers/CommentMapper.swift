//
//  CommentMapper.swift
//  Morak
//
//  Created by Hong jeongmin on 11/11/25.
//

import Foundation

// MARK: - DTO -> Entity Mapper
struct CommentMapper {
    // CommentDTO -> Comment Entity
    static func toDomain(_ dto: CommentDTO) -> Comment {
        return Comment(
            id: dto.id,
            content: dto.content,
            nickname: dto.nickname,
            userId: dto.userId,
            postId: dto.postId,
            parentId: dto.parentId,
            likeCount: dto.likeCount,
            likedByLoginUser: dto.likedByLoginUser,
            createdAt: dto.createdAt,
            modifiedAt: dto.modifiedAt,
            hasChildren: dto.hasChildren,
            deleted: dto.deleted
        )
    }

    // CommentListResponseDTO -> Domain Model
    static func toDomain(_ dto: CommentListResponseDTO) -> CommentListResponse {
        return CommentListResponse(
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

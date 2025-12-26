//
//  MyInfoMapper.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

enum MyInfoMapper {
    static func toDomain(_ dto: MyInfoDTO) -> MyInfo {
        return MyInfo(
            id: dto.id,
            email: dto.email,
            nickname: dto.nickname,
            loginType: dto.loginType,
            role: dto.role
        )
    }
}

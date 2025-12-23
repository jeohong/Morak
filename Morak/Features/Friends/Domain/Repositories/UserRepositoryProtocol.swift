//
//  UserRepositoryProtocol.swift
//  Morak
//
//  Created by Hong jeongmin on 12/23/25.
//

import Foundation

protocol UserRepositoryProtocol {
    func searchUsers(nickname: String) async throws -> [Friend]
}

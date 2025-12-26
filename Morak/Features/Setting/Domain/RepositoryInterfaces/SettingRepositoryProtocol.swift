//
//  SettingRepositoryProtocol.swift
//  Morak
//
//  Created by Hong jeongmin on 12/26/25.
//

import Foundation

protocol SettingRepositoryProtocol {
    func getMyInfo() async throws -> MyInfo
    func withdraw() async throws -> String
}

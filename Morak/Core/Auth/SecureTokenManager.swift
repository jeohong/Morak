//
//  SecureTokenManager.swift
//  Morak
//
//  Created by Hong jeongmin on 9/12/25.
//

import Foundation
import Security

final class SecureTokenManager {
    static let shared = SecureTokenManager()
    
    private init() {}
    
    private let accessTokenKey = "access_token"
    private let refreshTokenKey = "refresh_token"
    private let serviceIdentifier = Bundle.main.bundleIdentifier ?? "com.brokong.Morak"
    
    // 앱 설치 추적용 UserDefaults 키
    private let appInstallUUIDKey = "app_install_uuid"
    
    func saveTokens(accessToken: String, refreshToken: String) async {
        // 앱 설치 UUID 생성 (최초 실행 시에만)
        ensureAppInstallUUID()
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                self.saveToKeychain(key: self.accessTokenKey, value: accessToken)
            }
            group.addTask {
                self.saveToKeychain(key: self.refreshTokenKey, value: refreshToken)
            }
        }
    }
    
    func getAccessToken() -> String? {
        guard isValidAppInstallation() else {
            // 앱이 재설치되었다면 키체인 데이터 무효화
            clearTokens()
            return nil
        }
        return getFromKeychain(key: accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        guard isValidAppInstallation() else {
            clearTokens()
            return nil
        }
        return getFromKeychain(key: refreshTokenKey)
    }
    
    func clearTokens() {
        deleteFromKeychain(key: accessTokenKey)
        deleteFromKeychain(key: refreshTokenKey)
        
        // 앱 UUID도 삭제 (로그아웃 시)
        UserDefaults.standard.removeObject(forKey: appInstallUUIDKey)
    }
    
    // MARK: - Private Methods
    
    private func ensureAppInstallUUID() {
        if UserDefaults.standard.string(forKey: appInstallUUIDKey) == nil {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: appInstallUUIDKey)
        }
    }
    
    private func isValidAppInstallation() -> Bool {
        // UserDefaults에 UUID가 있다 = 같은 앱 설치
        // UserDefaults에 UUID가 없다 = 앱이 삭제되었다가 재설치됨
        return UserDefaults.standard.string(forKey: appInstallUUIDKey) != nil
    }
    
    private func saveToKeychain(key: String, value: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: serviceIdentifier,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: serviceIdentifier,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else { return nil }
        guard let data = item as? Data else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
    
    private func deleteFromKeychain(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: serviceIdentifier,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

//
//  KeyChainWrapper.swift
//  CodeProject
//
//  Created by Alex Fu on 11/25/20.
//
import Foundation
import Security

protocol KeyChainWrapper {
    func hasToken() -> Bool
    func setToken(_ token: String)
    func getToken() -> String?
    func removeToken()
}

class KeyChainWrapperImpl: KeyChainWrapper {
    private let key: String = "HTKey"

    func setToken(_ token: String) {
        let keychainItemQuery = [
            kSecValueData: token.data(using: .utf8)!,
            kSecAttrServer: key,
            kSecClass: kSecClassInternetPassword,
        ] as CFDictionary

        let status = SecItemAdd(keychainItemQuery, nil)
        printErrorIfAny(status: status)
    }

    func getToken() -> String? {
        let keychainItem = [
            kSecAttrServer: key,
            kSecClass: kSecClassInternetPassword,
            kSecReturnData: true,
        ] as CFDictionary

        var ref: AnyObject?

        let status = SecItemCopyMatching(keychainItem, &ref)
        printErrorIfAny(status: status)

        if let result = ref as? Data {
            let token = String(data: result, encoding: .utf8)!
            return token
        }
        return nil
    }

    func hasToken() -> Bool {
        return getToken() != nil
    }

    func removeToken() {
        let keychainItem = [
            kSecAttrServer: key,
            kSecClass: kSecClassInternetPassword,
        ] as CFDictionary
        SecItemDelete(keychainItem)
    }

    private func printErrorIfAny(status: OSStatus) {
        if status != errSecSuccess, let error: String = SecCopyErrorMessageString(status, nil) as String? {
            print(error)
        }
    }
}

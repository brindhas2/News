//
//  KeychainWrapper.swift
//  RoboSoftNews
//
//  Created by Brindha S on 19/07/23.
//

import Foundation

/**
 A class can be used to store the credentials
 */
open class KeychainWrapper: NSObject {
    
    /**
     Method can be used to setup the dictionary for search key and its value.
     
     - Parameter identifier: is kind of String, Can be used to identify the file/dictionary in specific path.
     - Returns: is kind of AnyHashable, Have account and keychain information of the user who using the device.
     */
    open class func setupSearchDirectory(forIdentifier identifier: String, config: DataConfiguration) -> [AnyHashable: Any] {
        // Setup dictionary to access keychain.
        var searchDictionary = [AnyHashable: Any]()
        // Specify we are using a password (rather than a certificate, internet password, etc).
        searchDictionary[kSecClass] = kSecClassGenericPassword
        // Uniquely identify this keychain accessor.
        searchDictionary[kSecAttrService] = config.keychainService
        // If access group value is present set that value
        if let accessGroupValue = config.keychainAccessGroup {
            searchDictionary[kSecAttrAccessGroup] = accessGroupValue
        }
        // Uniquely identify the account who will be accessing the keychain.
        let encodedIdentifier: Data? = identifier.data(using: .utf8)
        searchDictionary[kSecAttrGeneric] = encodedIdentifier
        searchDictionary[kSecAttrAccount] = encodedIdentifier
        return searchDictionary
    }
    
    /**
     Generic exposed method to search the keychain for a given value. Limit one result per search.
     
     - Parameter identifier: is kind of String, Can be used to identify the file/dictionary in specific path.
     - Returns: is kind of Data, Have search result from keychain.
     */
    open class func searchKeychainCopy(matchingIdentifier identifier: String, config: DataConfiguration) -> Data {
        var searchDictionary = setupSearchDirectory(forIdentifier: identifier, config: config)
        // Limit search results to one.
        searchDictionary[kSecMatchLimit] = kSecMatchLimitOne
        // Specify we want NSData/CFData returned.
        searchDictionary[kSecReturnData] = kCFBooleanTrue
        // Search.
        var result: Data? = nil
        var foundDict: CFTypeRef? = nil
        let status: OSStatus = SecItemCopyMatching(searchDictionary as CFDictionary, &foundDict)
        
        if status == noErr {
            result = foundDict as? Data
        }
        else{
            result = nil
        }
        return result ?? Data()
    }
    
    /**
     Calls searchKeychainCopyMatchingIdentifier: and converts to a string value.
     
     - Parameter identifier: is kind of String, Can be used to identify the file/dictionary in specific path.
     - Returns: is kind of String, Will give keychain string using matching identifier from keychain.
     */
    open class func keychainStringFrom(matchingIdentifier identifier: String, config: DataConfiguration) -> String {
        let valueData: Data? = searchKeychainCopy(matchingIdentifier: identifier, config: config)
        if valueData != nil {
            let value = String(data: valueData ?? Data(), encoding: .utf8)
            return value!
        }
        else {
            return ""
        }
    }
    
    /**
     Default initializer to store a value in the keychain.
     Associated properties are handled for you - setting Data Protection Access, Company Identifer (to uniquely identify string, etc).
     
     - Parameter value: is kind of Any, Actual data/information about the keychain.
     - Parameter identifier: is kind of String, Can be used to identify the file/dictionary in specific path.
     - Returns: is kind of Bool, Will intimate that the keychain value has created or not.
     */
    open class func createKeychainValue(_ value: Any, forIdentifier identifier: String, config: DataConfiguration) -> Bool {
        var dictionary = setupSearchDirectory(forIdentifier: identifier, config: config)
        var valueData: Data?
        if (value is String) {
            valueData = (value as! String).data(using: .utf8)
        }
        else {
            valueData = value as? Data
        }
        dictionary[kSecValueData] = valueData
        if config.isAccessibleInBackground {
            dictionary[kSecAttrAccessible] = kSecAttrAccessibleAlwaysThisDeviceOnly
        } else {
            // Protect the keychain entry so it's only valid when the device is unlocked.
            dictionary[kSecAttrAccessible] = kSecAttrAccessibleWhenUnlocked
        }
        // Add.
        let status: OSStatus = SecItemAdd((dictionary as CFDictionary), nil)
        // If the addition was successful, return. Otherwise, attempt to update existing key or quit (return NO).
        if status == errSecSuccess {
            return true
        }
        else if status == errSecDuplicateItem {
            return updateKeychainValue(value, forIdentifier: identifier, config: config)
        }
        else {
            return false
            // SecBase.h
            // errSecMissingEntitlement     = -34018
        }
    }
    
    /**
     Updates a value in the keychain.
     If you try to set the value with createKeychainValue: and it already exists,this method is called instead to update the value in place.
     
     - Parameter value: is kind of Any, Actual data/information about the keychain.
     - Parameter identifier: is kind of String, Can be used to identify the file/dictionary in specific path.
     - Returns: is kind of Bool, Will intimate that the keychain value has created or not.
     */
    open class func updateKeychainValue(_ value: Any, forIdentifier identifier: String, config: DataConfiguration) -> Bool {
        let searchDictionary = setupSearchDirectory(forIdentifier: identifier, config: config)
        var updateDictionary = [AnyHashable: Any]()
        var valueData: Data?
        if (value is String) {
            valueData = (value as! String).data(using: .utf8)
        }
        else {
            valueData = value as? Data
        }
        updateDictionary[kSecValueData] = valueData
        // Update.
        let status: OSStatus = SecItemUpdate((searchDictionary as CFDictionary), (updateDictionary as CFDictionary))
        if status == errSecSuccess {
            return true
        }
        else {
            return false
        }
    }
    
    /**
     Delete a value in the keychain.
     
     - Parameter identifier: is kind of String, Can be used to identify the file/dictionary in specific path.
     */
    open class func deleteItemFromKeychain(withIdentifier identifier: String, config: DataConfiguration) {
        let searchDictionary = setupSearchDirectory(forIdentifier: identifier, config: config)
        let dictionary = searchDictionary as CFDictionary
        //Delete.
        SecItemDelete(dictionary)
    }
}

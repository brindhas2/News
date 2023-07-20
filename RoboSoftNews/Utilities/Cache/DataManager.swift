//
//  DataManager.swift
//  RoboSoftNews
//
//  Created by Brindha S on 19/07/23.
//

import Foundation

/// handling User data
public class DataManager: NSObject {
    
    /// Singlton Object
    public static let sharedInstance = DataManager()
    
    /**
     Saving object with Secure key
     - Parameters:
     - object: User data
     - key: string
     - isSecureKey: Boolean
     */
    public func save(_ object: Any?, withKey key: String?, isSecureKey: Bool = true, config: DataConfiguration) {
        if isSecureKey {
            var encodedObject: Data? = nil
            if let anObject = object {
                encodedObject = NSKeyedArchiver.archivedData(withRootObject: anObject)
            }
            _ = KeychainWrapper.createKeychainValue(encodedObject as Any, forIdentifier: key ?? "", config: config)
        } else {
            var encodedObject: Data? = nil
            if let anObject = object {
                encodedObject = NSKeyedArchiver.archivedData(withRootObject: anObject)
            }
            config.userDefaults.setValue(encodedObject, forKey: key ?? "")
            config.userDefaults.synchronize()
        }
    }
    
    /**
     Removing object
     - Parameter key: String value
     */
    public func removeObject(withKey key: String?, isSecureKey: Bool = true, config: DataConfiguration) {
        removeObject(withKey: key ?? "", synchronize: true, config: config)
    }
    
    /**
     Removing object
     - Parameter key: String value
     - synchronize: Boolean
     */
    public func removeObject(withKey key: String?, synchronize: Bool, isSecureKey: Bool = true, config: DataConfiguration) {
        if isSecureKey {
            removeObjectFromKeychain(withKey: key, config: config)
        } else {
            removeObjectFromNSUserDefaults(withKey: key, synchronize: synchronize, config: config)
        }
    }
    /**
     Removing Object from Keychain
     - Parameter key: String
     */
    private func removeObjectFromKeychain(withKey key: String?, config: DataConfiguration) {
        KeychainWrapper.deleteItemFromKeychain(withIdentifier: key ?? "", config: config)
    }
    
    /**
     Removing Objects from UserDefaults
     - Parameters:
     - key: String Value
     - synchronize: Boolean
     */
    private func removeObjectFromNSUserDefaults(withKey key: String?, synchronize: Bool, config: DataConfiguration) {
        config.userDefaults.removeObject(forKey: key ?? "")
        if synchronize {
            config.userDefaults.synchronize()
        }
    }
    
    /**
     Getting Object using key from keychain
     - Parameter key: String
     - Returns: Object
     */
    public func getObjectWithKey(_ key: String?, isSecureKey: Bool = true, config: DataConfiguration) -> Any? {
        var result: Any? = nil
        if isSecureKey {
            result = getObjectFromKeychain(withKey: key, config: config)
        } else {
            result = getObjectFromNSUserDefaults(withKey: key, config: config)
        }
        return result
    }
    /**
     Getting value from Userdefaults
     - Parameter key: Key string
     - Returns: Value
     */
    private func getObjectFromNSUserDefaults(withKey key: String?, config: DataConfiguration) -> Any? {
        let encodedObject = config.userDefaults.object(forKey: key ?? "") as? Data
        var object: Any? = nil
        if encodedObject != nil, let anObject = encodedObject {
            object = NSKeyedUnarchiver.unarchiveObject(with: anObject)
        }
        return object
    }
    /**
     Getting value from Keychain
     - Parameter key: Key string
     - Returns: Value
     */
    private func getObjectFromKeychain(withKey key: String?, config: DataConfiguration) -> Any? {
        let encodedObject: Data? = KeychainWrapper.searchKeychainCopy(matchingIdentifier: key ?? "", config: config)
        var object: Any? = nil
        if encodedObject != nil, let anObject = encodedObject {
            object = NSKeyedUnarchiver.unarchiveObject(with: anObject)
        }
        if object == nil {
            return nil
        }
        return object
    }
}

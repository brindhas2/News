//
//  UtilsCacheManager.swift
//  RoboSoftNews
//
//  Created by Brindha S on 19/07/23.
//

import Foundation

public final class UtilsCacheManager: NSObject {
    //Shared instance of the configurator
    public static let shared = UtilsCacheManager()
    var configuration: DataConfiguration
    var suiteName: String?
    var keychainServiceValue: String
    var keychainAccessGroupValue: String?
 

    //Initializer access level is private
    private override init() {
    
        configuration = DataConfiguration()
        suiteName = UtilsCacheManager.getAppGroupSuiteName()
        keychainServiceValue = UtilsCacheManager.getKeychainAccessService()
        keychainAccessGroupValue = UtilsCacheManager.getKeychainAccessGroupName()
    }
    
    
    /// Reference that stores user id entered by the user.
    var kUserName: String?
    public var userName: String? {
        get {
            if let propertyValue = getProperty(key: UtilsConstants.username, isSecureKey: true) as? String {
                return propertyValue
            }
            return nil
        }
        set {
            kUserName = newValue
            saveProperty(key: UtilsConstants.username, value: kUserName)
        }
    }

    /// Reference that stores user id entered by the user.
    var kPswd: String?
    public var password: String? {
        get {
            if let propertyValue = getProperty(key: UtilsConstants.pswd, isSecureKey: true) as? String {
                return propertyValue
            }
            return nil
        }
        set {
            kPswd = newValue
            saveProperty(key: UtilsConstants.username, value: kPswd)
        }
    }

    
    public func getDataConfiguration(for key: String) -> DataConfiguration {
        configuration.keychainService = keychainServiceValue
        
        return configuration
    }

    /**
     Set the property based on selected profile
     -Parameter
     */
    public func saveProperty(key: String, value: Any?, isSecureKey: Bool = false) {
        if value != nil {
            let config = getDataConfiguration(for: key)
            DataManager.sharedInstance.save(value, withKey:  key, isSecureKey: isSecureKey, config: config)
        }
    }
    
    /**
     Get the Saved property value based on selected profile key
     */
    public func getProperty(key: String, isSecureKey: Bool = false) -> Any? {
        let config = getDataConfiguration(for: key)
        let propertyValue = DataManager.sharedInstance.getObjectWithKey(key, isSecureKey: isSecureKey, config: config)
        if let keyValue = propertyValue {
            return keyValue
        } else {
            return nil
        }
    }
    
    /**
     Remove the Saved property value based on selected profile key
     */
    public func removeProperty(key: String, _ isSecureKey: Bool = false) {
        let config = getDataConfiguration(for: key)
        DataManager.sharedInstance.removeObject(withKey: key, isSecureKey: isSecureKey, config: config)
    }
    
 
    /**
     Method to check key already saved
     */
    public func contains(key: String, _ isSecureKey: Bool = false) -> Bool {
        return getProperty(key: key, isSecureKey: isSecureKey) != nil
    }
    
}

extension UtilsCacheManager {
    static func getAppGroupSuiteName() -> String {
        let suitname = "group." + self.appGroupBundleIdentifier()
        return suitname
    }
    
    static func getKeychainAccessService() -> String {
        let accessGroup = self.appGroupBundleIdentifier()
        return accessGroup
    }
    
    static func getKeychainAccessGroupName() -> String {
        let value = getKeychainAccessService()
        if let identifier = Bundle.main.infoDictionary?["AppIdentifierPrefix"] as? String {
            return String(format: "%@%@", identifier, value)
        }
        return value
    }
    
    static func getBundleIdentifier() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    static func appGroupBundleIdentifier() -> String {
        var appGroupIdentifier = ""
        if let dict = Bundle.main.infoDictionary, let value = (dict["AppGroupBundleIdentifier"] as? String) {
            appGroupIdentifier = value
        }
        return appGroupIdentifier
    }
}

public struct DataConfiguration {
    /// Suite name to be used instead of standard defaults (Provide value only if need to be accessed from app group)
    public var suiteName: String?
    /// Keychain - access group value (Provide value only if need to be accessed from app group while using keychain)
    public var keychainAccessGroup: String?
    /// Keychain - service value
    public var keychainService: String
    /// Keychain - decides whether key is accessible in background
    public var isAccessibleInBackground: Bool = false

    public init() {
        keychainService = ""
    }
    
    public init(serviceValue: String) {
        keychainService = serviceValue
    }

    /// Gives the user defaults based on the suite name provided criteria
    public var userDefaults: UserDefaults {
        guard let suite = suiteName else {
            return UserDefaults.standard
        }
        return UserDefaults(suiteName: suite) ?? UserDefaults.standard
    }
}

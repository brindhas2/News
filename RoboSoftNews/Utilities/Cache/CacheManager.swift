//
//  CacheManager.swift
//  RoboSoftNews
//
//  Created by Brindha S on 19/07/23.
//

import Foundation

/**
 Protocol definition for managing cache exclusive to bill pay.
 */
protocol CacheProtocol {
    func saveInCache<T>(_ data: T?)
    func getFromCache<T>() -> T?
    func clearInCache()
}

/**
 Cache manager that comprises various cases for bill pay cache.
 */
public enum CacheManager: String, CacheProtocol {
    
    // Case for storing/retrieving login response.
    case favoriteItem = "favoriteItem"
    
    /**
     Method that helps to save the provided data in cache.
     */
    public func saveInCache<T>(_ data: T?) {
        CacheConfigurator.sharedInstance.save(data: data, forKey: self.rawValue)
    }
    
    /**
     Method that will retrieve the cached data for the callers cache key.
     */
    public func getFromCache<T>() -> T? {
        
        return CacheConfigurator.sharedInstance.getData(forKey: self.rawValue)
        
    }
    
    /**
     Method that will help to clear the cached data for the callers cache key.
     */
    public func clearInCache() {
        CacheConfigurator.sharedInstance.clearData(forKey: self.rawValue)
    }
}

/**
 Cache manager class which do the basic caching activities.
 */
final public class CacheConfigurator: CacheConfiguratorProtocol {

    // MARK: - Shared Instance
    
    static public let sharedInstance = CacheConfigurator()
    /// Dictionary object that stores the data in the given key.
    private var cachedInfo: [String: Any]

    // Initialize the dictionary object.
    private init() {
        cachedInfo = [String: Any]()
    }

    // MARK: - Cache Protocol Implementation
    
    /**
     Method that will store the data in cache dictionary for the given key.
     - Parameter data: data to be saved.
     - Parameter forKey: key value.
     */
    public func save<T>(data: T, forKey: String) {
        cachedInfo.updateValue(data, forKey: forKey)
    }
    
    /**
     Method that will retrieve the data in cache dictionary for the given key.
     - Parameter forKey: key value.
     */
    public func getData<T>(forKey: String) -> T? {
        guard let cachedData = cachedInfo[forKey] as? T else {
            return nil
        }
        return cachedData
    }
    
    /**
     Method that will clear the data in cache dictionary for the given key.
     - Parameter forKey: key value.
     */
    public func clearData(forKey: String) {
        guard let keyIndex = cachedInfo.index(forKey: forKey) else {
            return
        }
        cachedInfo.remove(at: keyIndex)
    }

    /**
     Method that will clear all the key value pairs in cache dictionary.
     */
    public func clearAll() {
        cachedInfo.removeAll()
    }
    
    // MARK: - Clear Cache
    
    /**
     Method when called will clear all the cached data so far. Usually used to clear data when user logout.
     */
    public func clearCache() {
        clearAll()
    }
}
/**
 Protocol definition for managing cache exclusive to bill pay.
 */
protocol CacheConfiguratorProtocol {
    func save<T>(data: T, forKey: String)
    func clearData(forKey: String)
    func getData<T>(forKey: String) -> T?
    func clearAll()
}

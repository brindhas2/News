//
//  RSNetworkRequest.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import Foundation
import Alamofire

enum RequestBuilder {
    case news
}

// MARK: - Extensions
// MARK: - EndPointType
extension RequestBuilder: RequestType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String {
        switch NetworkManager.networkEnviroment {
            case .dev: return "https://newsapi.org"
            case .production: return "https://newsapi.org/prod/"
            case .stage: return "https://newsapi.org/staging/"
        }
    }
    
    var version: String {
        return "/v2"
    }
    
    var path: String {
        switch self {
            
        case .news:
            return "/v2/everything"
       
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .news:
           // let dateString = RSDateFormatter.stringFromDate(Date(), toStringWithFormat: DateFormatterString.shortDateFormat)
            return ["q": "tesla", "from" : "2023-06-28", "sortBy": "publishedAt", "apiKey": "d6e6886d0f8c46f18793b5d35cd833f1"]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .news:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
     return nil
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
   
    
}

protocol RequestType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? {get}
    
}

enum NetworkEnvironment {
    case dev
    case production
    case stage
}

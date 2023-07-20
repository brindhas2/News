//
//  NetworkManager.swift
//  RoboSoftNews
//
//  Created by Brindha S on 18/07/23.
//

import Foundation
import Alamofire

class NetworkManager {
    
    // MARK: - Vars & Lets
    
    private var sessionManager: Session = Session()
    static let networkEnviroment: NetworkEnvironment = .dev
    
    // MARK: - Vars & Lets
    
    static var sharedApiManager: NetworkManager = {
        let apiManager = NetworkManager(sessionManager: Session())
        
        return apiManager
    }()
    
    // MARK: - Accessors
    
    class func shared() -> NetworkManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization
    
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    func call<T>(type: RequestType, handler: @escaping (T?, _ error: ErrorDetail?)->()) where T: Codable {
       
            self.sessionManager.request(type.url,
                                        method: type.httpMethod,
                                        parameters: type.parameters,
                                        encoding: type.encoding,
                                        headers: type.headers).validate().responseJSON { data in
                                            switch data.result {
                                            case .success(_):
                                                let decoder = JSONDecoder()
                                                if let jsonData = data.data {
                                                    let result = try! decoder.decode(T.self, from: jsonData)
                                                    handler(result, nil)
                                                }
                                                break
                                            case .failure(_):
                                                handler(nil, self.parseApiError(data: data.data))
                                                break
                                            }
            }
        }
    
   
    private func parseApiError(data: Data?) -> ErrorDetail {
            let decoder = JSONDecoder()
        if let jsonData = data, let error = try? decoder.decode(RSError.self, from: jsonData) {
            return ErrorDetail(errorCode: error.code, title: error.status, message: error.message)
            }
        return ErrorDetail()
        }
    
}


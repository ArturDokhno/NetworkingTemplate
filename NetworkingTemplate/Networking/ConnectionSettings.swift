//
//  ConnectionSettings.swift
//  NetworkingTemplate
//
//  Created by Артур Дохно on 24.11.2021.
//

import Foundation
import Alamofire

struct Connectionsettings {}

extension Connectionsettings {
    static func sessionManager() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        let sessionManager = Session(configuration: configuration,
                                     startRequestsImmediately: false)
        return sessionManager
    }
    
}

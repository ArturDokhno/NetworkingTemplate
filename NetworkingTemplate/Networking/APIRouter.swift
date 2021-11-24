//
//  APIRouter.swift
//  NetworkingTemplate
//
//  Created by Артур Дохно on 24.11.2021.
//

import Foundation
import Alamofire

struct APIRouterStructer: URLRequestConvertible {
    
    var apiRouter: APIRouter
    
    func headers() -> HTTPHeaders {
        var headersDictionary = [
            "Accept": "application/json",
            "Origin": "some origin"
        ]
        if let additionalHeaders = apiRouter.additionalHeaders {
            let additionalHeaderDictionary = additionalHeaders.dictionary
            additionalHeaderDictionary.forEach { (key, value) in
                headersDictionary[key] = value
            }
        }
        return HTTPHeaders(headersDictionary)
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try apiRouter.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(apiRouter.path))
        urlRequest.httpMethod = apiRouter.method.rawValue
        urlRequest.timeoutInterval = apiRouter.timeout
        urlRequest.headers = headers()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = apiRouter.body {
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                urlRequest.httpBody = data
            } catch {
                print{"Fail to generate JSON data"}
            }
        }
        
        if let parameters = apiRouter.parameters {
            urlRequest = try apiRouter.encoding.encode(urlRequest, with: parameters)
        }
        print("urlREquest\(urlRequest)")
        return urlRequest
    }
    
}

enum APIRouter {
    
    // MARK: - Endpoints
    
    case todos(number: Int)
    
    var baseURL: String {
        switch self {
        case .todos: return "https://jsonplaceholder.typicode.com"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .todos: return .get
        }
    }
    
    var path: String {
        switch self {
        case let .todos(number):
            return "todos/\(number)"
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        default: return URLEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .todos: return nil
        }
    }
    
    var body: Parameters? {
        switch self {
        case .todos: return nil
        }
    }
    
    var additionalHeaders: HTTPHeaders? {
        switch self {
        case .todos: return HTTPHeaders(["Token": "Some Token"])
        }
    }
    
    var timeout: TimeInterval {
        switch self {
        default: return 20
        }
    }
    
}

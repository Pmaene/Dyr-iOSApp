//
//  EventRouter.swift
//  Dyr
//
//  Created by Pieter Maene on 26/04/15.
//  Copyright (c) 2015. All rights reserved.
//

import Alamofire
import Foundation

enum EventRouter: URLRequestConvertible {
    static let baseURLString = Constants.value(forKey: "APIBaseURL") + "/api/v1/events"
    
    case events(accessory: Accessory)
    
    var method: HTTPMethod {
        switch self {
        case .events:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .events:
            return "/"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case let .events(accessory):
                return (path, ["accessory": accessory.identifier])
            }
        }()
        
        let url = try DoorRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = JWTClient.sharedClient.token {
            urlRequest.setValue("Bearer \(token.rawValue)", forHTTPHeaderField: "Authorization")
        }
        
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
}

//
//  APIModel.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-08.
//

import Foundation

struct APIModel {
    static private let key: String = "YOUR API KEY"
    
    static private let headers_Main = [
        "x-rapidapi-key": APIModel.key,
        "x-rapidapi-host": "cricbuzz-cricket.p.rapidapi.com"
    ]
    
    static private let headers_API2 = [
        "x-rapidapi-key": APIModel.key,
        "x-rapidapi-host": "cricbuzz-cricket2.p.rapidapi.com"
    ]
    
    static private let cricAPIVersion_01: String = "https://cricbuzz-cricket.p.rapidapi.com/"
    static private let cricAPI2Version_01: String = "https://cricbuzz-cricket2.p.rapidapi.com/"
    
    static private let isMainAPI: Bool = true
    
    static func getRequest(_ type: DataType) -> URLRequest {
        let APIUrl: String = (APIModel.isMainAPI ? APIModel.cricAPIVersion_01 : APIModel.cricAPI2Version_01) + type.endPoint
        AppLogger.shared.debug("current API url \(APIUrl)")
        var request = URLRequest(url: URL(string: APIUrl)!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = APIModel.isMainAPI ? APIModel.headers_Main : APIModel.headers_API2
        return request
    }
}

extension DataType {
    var endPoint: String {
        switch self {
        case .teams:
            "teams/v1/international"
        case .players(let teamId):
            "teams/v1/\(teamId)/players"
        case .image(id: let id):
            "img/v1/i1/c\(id)/i.jpg"
        }
    }
}

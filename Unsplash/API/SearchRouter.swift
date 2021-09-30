//
//  SearchRouter.swift
//  Unsplash
//
//  Created by SeongMinK on 2021/09/30.
//

import Foundation
import Alamofire

// 검색 관련 API
enum SearchRouter: URLRequestConvertible {
    
    case searchPhotos(term: String)
    case searchUsers(term: String)
        
    var baseURL: URL {
        return URL(string: API.BASE_URL + "search/")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var endPoint: String {
        switch self {
        case .searchPhotos:
            return "photos/"
        case .searchUsers:
            return "users/"
        }
    }
    
    var parameters: [String: String] {
        switch self {
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query": term]
        }
    }
        
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
        
        print("SearchRouter - asURLRequest() called / url: \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
        return request
    }
}

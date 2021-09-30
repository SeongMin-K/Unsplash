//
//  Logger.swift
//  Unsplash
//
//  Created by SeongMinK on 2021/09/30.
//

import Foundation
import Alamofire

final class Logger: EventMonitor {
    let queue = DispatchQueue(label: "Logger")
    
    func requestDidResume(_ request: Request) {
        print("Logger - requestDidResume() called")
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("Logger - request.didParseResponse()")
        debugPrint(response)
    }
}

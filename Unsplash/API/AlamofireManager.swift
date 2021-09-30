//
//  AlamofireManager.swift
//  Unsplash
//
//  Created by SeongMinK on 2021/09/30.
//

import Foundation
import Alamofire

final class AlamofireManager {
    // 싱글톤 적용
    static let shared = AlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
    [
        BaseInterceptor()
    ])
    
    // 로거 설정
    let monitors = [Logger()] as [EventMonitor]
    
    // 세션 설정
    var session: Session
    
    private init() {
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }

}

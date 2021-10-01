//
//  AlamofireManager.swift
//  Unsplash
//
//  Created by SeongMinK on 2021/09/30.
//

import Foundation
import Alamofire
import SwiftyJSON

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
        session = Session(
            interceptor: interceptors,
            eventMonitors: monitors
        )
    }

    func getPhotos(searchTerm userInput: String, completion: @escaping (Result<[Photo], MyError>) -> Void) {
        print("MyAlamofireManger - getPhotos() called / userInput: \(userInput)")
        
        self.session
            .request(SearchRouter.searchPhotos(term: userInput))
            .validate(statusCode: 200..<401)
            .responseJSON(completionHandler: { response in
                
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                let jsonArray = responseJson["results"]
                var photos = [Photo]()
                
                for (index, subJson): (String, JSON) in jsonArray {
                    print("index: \(index), subJson: \(subJson)")
                    
                    // 데이터 파싱
                    guard let thumbnail = subJson["urls"]["thumb"].string,
                          let userName = subJson["user"]["username"].string,
                          let createdAt = subJson["created_at"].string else { return }
                    let likesCount = subJson["likes"].intValue
                    
                    let photoItem = Photo(thumbnail: thumbnail, userName: userName, likesCount: likesCount, createdAt: createdAt)
                        
                    // 배열에 삽입
                    photos.append(photoItem)
                }
                
                if photos.count > 0 {
                    completion(.success(photos))
                } else {
                    completion(.failure(.noContent))
                }
                
                
            })
    }
}

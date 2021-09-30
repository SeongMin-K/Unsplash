//
//  Constants.swift
//  Unsplash
//
//  Created by SeongMinK on 2021/09/29.
//

import Foundation

enum SEGUE_ID {
    static let USER_LIST_VC = "toUserListVC"
    static let PHOTO_COLLECTION_VC = "toPhotoCollectionVC"
}

enum API {
    static let BASE_URL: String = "https://api.unsplash.com/"
    static let CLIENT_ID: String = "5Ku4QqRxh997q6-RxcZe2MVS5I5VNnKrfJ4SuF8b86w"
}

enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}

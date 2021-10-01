//
//  Photo.swift
//  Unsplash
//
//  Created by SeongMinK on 2021/10/01.
//

import Foundation

struct Photo: Codable {
    var thumbnail: String
    var userName: String
    var likesCount: Int
    var createdAt: String
}

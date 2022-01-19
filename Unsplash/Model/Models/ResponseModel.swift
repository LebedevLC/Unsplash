//
//  ResponseModel.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 19.01.2022.
//

import Foundation

struct ResultsModel: Codable {
    let results: [ResponseModel]?
}

struct ResponseModel: Codable {
    let id: String?
    let views: Int?
    let downloads: Int?
    let likes: Int?
    let urls: Urls?
    let user: User?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case urls
        case user,views, downloads, likes
    }
}

// MARK: - Urls

struct Urls: Codable {
    let raw, full, regular, small: String?
    let thumb: String?
}

// MARK: - User

struct User: Codable {
    let id: String?
    let username, name: String?
    let location: String?
}

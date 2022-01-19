//
//  CellModel.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 19.01.2022.
//

import Foundation

struct CellModel: Codable {
    let id: String
    let name: String
    let date: String
    let imageSmall: URL?
    let imageThumb: URL?
    let downloadsCount: Int
    let likesCount: Int
    let location: String
    var isFavorite: Bool = false
}

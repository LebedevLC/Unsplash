//
//  SimpleFactory.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 19.01.2022.
//

import Foundation

final class SimpleFactory {
    
    func constructModelsCell(from response: [ResponseModel], completion: (([CellModel]) -> Void)) {
        let model = response.compactMap(self.cellViewModel)
        completion(model)
    }
    
    private func cellViewModel(from response: ResponseModel) -> CellModel {
        let id = response.id ?? ""
        let name = response.user?.name ?? ""
        
        var date = ""
        let word = response.createdAt ?? ""
        if let index = word.range(of: "T")?.lowerBound {
            let substring = word[..<index]
            date = String(substring)
        }
        
        let downloads = response.downloads ?? 0
        let likes = response.likes ?? 0
        let location = response.user?.location ?? ""
        guard
            let small = response.urls?.small,
            let thumb = response.urls?.thumb
        else {
            return CellModel(id: id, name: name, date: date, imageSmall: nil, imageThumb: nil, downloadsCount: downloads, likesCount: likes, location: location)
        }
        let imageSmall = URL(string: small)
        let imageThumb = URL(string: thumb)
        return CellModel(id: id, name: name, date: date, imageSmall: imageSmall, imageThumb: imageThumb, downloadsCount: downloads, likesCount: likes, location: location)
    }
}

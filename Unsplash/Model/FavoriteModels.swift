//
//  FavoriteModels.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 19.01.2022.
//

import Foundation

final class FavoriteModels {
    static let shared = FavoriteModels()
    
    private let caretaker = Caretaker()
    
    private(set) var favorites: [CellModel] {
        didSet {
            caretaker.saveModel(model: self.favorites)
        }
    }
    
    private init() {
        self.favorites = self.caretaker.loadModel()
    }
    
    func addModel(_ model: CellModel) {
        self.favorites.append(model)
    }
    
    func deleteModel(_ model: CellModel) {
        self.caretaker.deleteModel(models: favorites, model: model)
        self.favorites = self.caretaker.loadModel()
    }
}

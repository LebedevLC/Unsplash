//
//  Caretaker.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 19.01.2022.
//

import Foundation

final class Caretaker {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private let defaultModel: [CellModel] = []
    private let key = "cellModels"
    
    // MARK: - Save
    
    func saveModel(model: [CellModel]) {
        do {
            let data = try self.encoder.encode(model)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func deleteModel(models: [CellModel], model: CellModel) {
        do {
            let array = loadModel()
            let newArray = array.filter { $0.id != model.id }
            let data = try self.encoder.encode(newArray)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    // MARK: - Retrieve
    
    func loadModel() -> [CellModel] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return defaultModel
        }
        do {
            let models = try self.decoder.decode([CellModel].self, from: data)
            return models
        } catch {
            debugPrint(error.localizedDescription)
            return defaultModel
        }
    }
}

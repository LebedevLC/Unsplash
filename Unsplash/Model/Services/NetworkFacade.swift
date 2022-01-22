//
//  NetworkFacade.swift
//  Unsplash
//
//  Created by Сергей Чумовских on 19.01.2022.
//

import UIKit

final class NetworkFacade {
    
    private let factory = SimpleFactory()
    private let network = NetworkService()
    
    // max value 30 photos
    private let count: Int = 30
    
    weak var collectionPhotoRandomViewController: CollectionPhotoViewController?
    
    init(collectionPhotoRandomViewController: CollectionPhotoViewController) {
        self.collectionPhotoRandomViewController = collectionPhotoRandomViewController
    }
    
    func getPhotos(completion: @escaping () -> Void) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            self.network.getRandomPhotos(count: self.count) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.setCellModel(response: response, isSearch: false)
                    completion()
                case .failure:
                    debugPrint("ERROR")
                    completion()
                }
            }
        }
    }
    
    func searchPhotos(query: String) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            self.network.searchPhotos(query: query) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.setCellModel(response: response, isSearch: true)
                case .failure:
                    debugPrint("ERROR")
                }
            }
        }
    }
    
    // Factory
    private func setCellModel(response: [ResponseModel], isSearch: Bool) {
        guard let collectionPhotoRandomViewController = collectionPhotoRandomViewController else { return }
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            self.factory.constructModelsCell(from: response, completion: { model in
                switch isSearch {
                case false:
                    collectionPhotoRandomViewController.cellModel.append(contentsOf: model)
                case true:
                    collectionPhotoRandomViewController.cellModel = model
                }
            })
        }
    }
}

//
//  TableFavoriteViewController.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 18.01.2022.
//

import UIKit

class TableFavoriteViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private var models: [CellModel] = []
    
    // MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupTableView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        models = FavoriteModels.shared.favorites
        tableView.reloadData()
    }
}

// MARK: - TableView

extension TableFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        tableView.isUserInteractionEnabled = true
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoritePhotosTableViewCell.self, forCellReuseIdentifier: FavoritePhotosTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePhotosTableViewCell.identifier, for: indexPath) as? FavoritePhotosTableViewCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let secondViewController = DetailsVeiwController(presentModel: models[indexPath.row])
        let navVC = UINavigationController(rootViewController: secondViewController)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
}

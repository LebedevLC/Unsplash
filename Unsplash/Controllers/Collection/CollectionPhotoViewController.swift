//
//  CollectionPhotoViewController.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 18.01.2022.
//

import UIKit

class CollectionPhotoViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 320, height: 320)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private var tapGesture: UITapGestureRecognizer?
    private var keyboardIsHide: Bool = true
    private var isLoading: Bool = false
    private var query: String = ""
    private var networkFacade: NetworkFacade?
    
    var cellModel: [CellModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkFacade = NetworkFacade(collectionPhotoRandomViewController: self)
        networkFacade?.getPhotos(completion: {})
        setupCollection()
        setSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationOn()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        notificationOff()
    }
}

// MARK: - SearchBar

extension CollectionPhotoViewController: UISearchBarDelegate {
    
    private func setSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        networkFacade?.searchPhotos(query: self.query)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.query = searchText
    }
}

// MARK: - Keyboard

extension CollectionPhotoViewController {
    
    @objc private func keyboardWasShown(notification: Notification) {
        keyboardIsHide = false
        setMyTap()
    }
    
    @objc private func keyboardDidHideNotification(notification: Notification) {
        self.view.gestureRecognizers?.forEach(view.removeGestureRecognizer)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
        keyboardIsHide = true
    }
    
    private func setMyTap() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture!)
    }
    
    // MARK: - Notification
    
    private func notificationOn() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHideNotification(notification:)),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func notificationOff() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}

// MARK: - CollectionView

extension CollectionPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    private func setupCollection() {
        view.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PhotoRandomCollectionCell.self, forCellWithReuseIdentifier: PhotoRandomCollectionCell.identifier)
        
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            searchBar.heightAnchor.constraint(equalToConstant: 32),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4)
        ])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoRandomCollectionCell.identifier, for: indexPath) as? PhotoRandomCollectionCell
        else { return UICollectionViewCell() }
        let image = cellModel[indexPath.item].imageSmall
        cell.configure(with: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = DetailsVeiwController(presentModel: cellModel[indexPath.item])
        let navVC = UINavigationController(rootViewController: detailsVC)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let maxItems = indexPaths.map({$0.item}).max() else { return }
        if maxItems > cellModel.count - 5,
           !isLoading {
            isLoading = true
            networkFacade?.getPhotos(completion: {
                self.isLoading = false
            })
        }
    }
}

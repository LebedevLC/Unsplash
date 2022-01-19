//
//  HomeViewController.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 18.01.2022.
//

import UIKit
import Kingfisher

class DetailsVeiwController: UIViewController {
    
    let labelName: UILabel = {
        let label = UILabel()
        label.text = "AuthorNAME AuthorNAME"
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    let labelDate: UILabel = {
        let label = UILabel()
        label.text = "21.12.2021"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 0.9
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = .zero
        view.layer.cornerRadius = 12
        view.backgroundColor = .quaternaryLabel
        return view
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "photoHolder")
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.backgroundColor = .secondarySystemBackground
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let labelDownloads: UILabel = {
        let label = UILabel()
        label.text = "99999"
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    let labelLocation: UILabel = {
        let label = UILabel()
        label.text = "Canada"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    let imageLike: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "heart.fill")
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.showsVerticalScrollIndicator = false
        v.backgroundColor = .systemBackground
        return v
    }()
    
    private var likeGesture: UITapGestureRecognizer?
    
    var isFavorite: Bool {
        didSet {
            isFavorite ? likeAnimation(color: .red) : likeAnimation(color: .lightGray)
        }
    }
    private var panGesture: UIPanGestureRecognizer?
    
    var presentModel: CellModel
    
    // MARK: - LifeCicle
    
    init(presentModel: CellModel) {
        self.presentModel = presentModel
        isFavorite = presentModel.isFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupViews()
        setupBarButton()
        setupData()
        setTap()
       }
    
    // MARK: - BarButtons
    
    private func setupBarButton() {
        let logoutButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(logout))
        logoutButton.tintColor = .label
        navigationItem.setLeftBarButton(logoutButton, animated: true)
    }
    
    @objc private func logout() {
        dismiss(animated: true)
    }
    
    // MARK: - Gesture
    
    private func setupGesture() {
        likeGesture = UITapGestureRecognizer(target: self, action: #selector(likeTap))
        imageLike.addGestureRecognizer(likeGesture!)
    }
    
    @objc private func likeTap() {
        isFavorite.toggle()
        presentModel.isFavorite = self.isFavorite
        isFavorite ? FavoriteModels.shared.addModel(presentModel) : FavoriteModels.shared.deleteModel(presentModel)
    }
    
    // MARK: - SetupData
    
    private func setupData() {
        labelName.text = presentModel.name
        labelDate.text = presentModel.date
        labelLocation.text = presentModel.location
        presentModel.downloadsCount == 0 ? (labelDownloads.text = "\(presentModel.likesCount)") : (labelDownloads.text = "\(presentModel.downloadsCount)")
        image.kf.setImage(with: presentModel.imageSmall, placeholder: nil, options: [.transition(ImageTransition.fade(1) ) ] )
    }
    
    // MARK: - Views
    
    private func setupViews() {
        presentModel.isFavorite ? (imageLike.tintColor = .red) : (imageLike.tintColor = .lightGray)
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(labelName)
        scrollView.addSubview(labelDate)
        scrollView.addSubview(shadowView)
        scrollView.addSubview(labelDownloads)
        scrollView.addSubview(labelLocation)
        scrollView.addSubview(imageLike)
        
        shadowView.addSubview(image)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        labelDownloads.translatesAutoresizingMaskIntoConstraints = false
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        imageLike.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

            labelName.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            labelName.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            labelName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            labelDate.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelDate.trailingAnchor.constraint(equalTo: labelName.trailingAnchor),
            labelDate.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 12),
            labelDate.heightAnchor.constraint(equalToConstant: 17),
            
            shadowView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            shadowView.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 12),
            shadowView.heightAnchor.constraint(equalToConstant: 310),
            shadowView.widthAnchor.constraint(equalToConstant: 310),
            
            image.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            image.topAnchor.constraint(equalTo: shadowView.topAnchor),
            
            labelDownloads.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelDownloads.trailingAnchor.constraint(equalTo: labelName.trailingAnchor),
            labelDownloads.topAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: 12),
            labelDownloads.heightAnchor.constraint(equalToConstant: 23),
            
            labelLocation.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelLocation.trailingAnchor.constraint(equalTo: labelName.trailingAnchor),
            labelLocation.topAnchor.constraint(equalTo: labelDownloads.bottomAnchor, constant: 12),
            labelLocation.heightAnchor.constraint(equalToConstant: 18),
            
            imageLike.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageLike.topAnchor.constraint(equalTo: labelLocation.bottomAnchor, constant: 12),
            imageLike.heightAnchor.constraint(equalToConstant: 70),
            imageLike.widthAnchor.constraint(equalToConstant: 70),
            imageLike.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -4)
        ])
    }
    
    // MARK: - Animations
    
    private func likeAnimation(color: UIColor) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.imageLike.tintColor = color
            })
    }
}
    
// MARK: - SavingPhoto

extension DetailsVeiwController {
    
    // Double Tap
    private func setTap() {
        
        // Image
        let doubleTapImage: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTapImage))
        doubleTapImage.numberOfTapsRequired = 2
        image.addGestureRecognizer(doubleTapImage)
    }
    
    @objc func handleDoubleTapImage() {
        saveImage()
    }
    
    // Save
    private func saveImage() {
        guard let image = image.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_ :didFinishSavingWithError: contextInfo:)), nil)
    }
    
    // Alert
    @objc func image(_ image:UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        } else {
            let ac = UIAlertController(title: "Успех", message: "Фото успешно сохранено", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
}

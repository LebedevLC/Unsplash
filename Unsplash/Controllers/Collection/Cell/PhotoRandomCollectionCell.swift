//
//  PhotoRandomCollectionCell.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 18.01.2022.
//

import UIKit
import Kingfisher

class PhotoRandomCollectionCell: UICollectionViewCell {
    
    static let identifier = "PhotoRandomCollectionCell"
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.label.cgColor
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 8
        image.backgroundColor = .quaternaryLabel
        image.tintColor = .clear
        image.image = UIImage(named: "photoHolder")
        return image
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowOpacity = 0.9
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = .zero
        view.layer.cornerRadius = 8
        view.backgroundColor = .quaternaryLabel
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(shadowView)
        shadowView.addSubview(image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = UIImage(named: "photoHolder")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    private func setViews() {
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            image.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            image.topAnchor.constraint(equalTo: shadowView.topAnchor),
        ])
    }
    
    func configure(with image: URL?) {
        self.image.kf.setImage(with: image, placeholder: nil, options: [.transition(ImageTransition.fade(1) ) ] )
    }
}

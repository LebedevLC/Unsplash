//
//  FavoritePhotosTableViewCell.swift
//  Unsplash
//
//  Created by Сергей Чумовских  on 18.01.2022.
//

import UIKit
import Kingfisher

class FavoritePhotosTableViewCell: UITableViewCell {
    
    static let identifier = "FavoritePhotosTableViewCell"
    
    let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .quaternaryLabel
        view.layer.shadowOpacity = 0.9
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = .zero
        view.layer.cornerRadius = 12
        return view
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "photoHolder")
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 12
        image.backgroundColor = .quaternaryLabel
        return image
    }()
    
    let labelName: UILabel = {
        let label = UILabel()
        label.text = "AuthorNAME AuthorNAME AuthorNAME"
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = UIImage(named: "photoHolder")
        labelName.text = ""
    }
    
    private func setViews() {
        contentView.addSubview(shadowView)
        shadowView.addSubview(image)
        contentView.addSubview(labelName)
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        labelName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            shadowView.heightAnchor.constraint(equalToConstant: 150),
            shadowView.widthAnchor.constraint(equalToConstant: 150),
            
            image.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            image.topAnchor.constraint(equalTo: shadowView.topAnchor),
            
            labelName.leadingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: 24),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(with model: CellModel) {
        let url = model.imageThumb
        self.image.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1) ) ] )
        labelName.text = model.name
    }
}

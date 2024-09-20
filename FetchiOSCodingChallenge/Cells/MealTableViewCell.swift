//
//  MealTableViewCell.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation
import UIKit

class MealTableViewCell: UITableViewCell {
    
    static var identifier: String {
        String(describing: MealTableViewCell.self)
    }
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var imageShimmerView: ShimmerView = {
        let shimmerView = ShimmerView()
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        return shimmerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(meal: Meal) {
        nameLabel.text = meal.strMeal
        descriptionLabel.text = meal.idMeal
        
        if let image = meal.thumbnailImage {
            removeShimmerView()
            thumbnailImageView.image = image
        } else {
            configureShimmerView()
        }
    }
}

// MARK: - UI Related Methods
private extension MealTableViewCell {
    
    func setup() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 44),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 44),
            
            nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func removeShimmerView() {
        imageShimmerView.removeFromSuperview()
        thumbnailImageView.isHidden = false
    }
    
    func configureShimmerView() {
        thumbnailImageView.isHidden = true
        
        contentView.addSubview(imageShimmerView)
        
        NSLayoutConstraint.activate([
            imageShimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageShimmerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageShimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imageShimmerView.widthAnchor.constraint(equalToConstant: 44),
            imageShimmerView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}

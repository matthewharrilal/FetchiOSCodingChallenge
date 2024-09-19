//
//  MealDetailViewController.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/19/24.
//

import Foundation
import UIKit

class MealDetailViewController: UIViewController {
    private let mealsManager: MealsManager
    private let meal: Meal
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var shimmerView: ShimmerView = {
        let shimmerView = ShimmerView()
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        return shimmerView
    }()
    
    init(mealsManager: MealsManager, meal: Meal) {
        self.mealsManager = mealsManager
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
        
        Task {
            await mealsManager.setDelegate(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateView(for: meal.thumbnailImage)
    }
}

private extension MealDetailViewController {
    
    func setupView() {
        view.backgroundColor = .white
        // Prepare both views for potential use
        view.addSubview(imageView)
        view.addSubview(shimmerView)
        
        // Set initial layout as shimmer view (will switch if image exists)
        layoutShimmerView()
    }
    
    func updateView(for image: UIImage?) {
        if let thumbnailImage = image {
            imageView.image = thumbnailImage
            showImageView()
        } else {
            showShimmerView()
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showShimmerView() {
        imageView.removeFromSuperview()
        imageView.isHidden = true
        
        view.addSubview(shimmerView)
        shimmerView.isHidden = false
        layoutShimmerView()

    }
    
    func showImageView() {
        shimmerView.isHidden = true
        shimmerView.removeFromSuperview()
        
        view.addSubview(imageView)
        imageView.isHidden = false
        layoutImageView()
    }
    
    func layoutShimmerView() {
        NSLayoutConstraint.activate([
            shimmerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shimmerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            shimmerView.heightAnchor.constraint(equalToConstant: 88),
            shimmerView.widthAnchor.constraint(equalToConstant: 88)
        ])
    }
    
    func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 88),
            imageView.widthAnchor.constraint(equalToConstant: 88)
        ])
    }
}

extension MealDetailViewController: MealsManagerDelegate {
    
    func didFetchMealThumbnail(_ mealThumbnail: MealThumbnail) {
        guard mealThumbnail.id == meal.idMeal else {
            print("This meal we are updating the image view for is not the one we are currently displaying.")
            return
        }
        
        // Update the view with the new image
        updateView(for: mealThumbnail.image)
    }
}

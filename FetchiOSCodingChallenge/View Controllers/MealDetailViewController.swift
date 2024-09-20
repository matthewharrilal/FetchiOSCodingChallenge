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
    
    // UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
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
    
    private let nameLabel = UILabel.createDetailLabel()
    private let categoryLabel = UILabel.createDetailLabel()
    private let instructionsLabel = UILabel.createDetailLabel()
    private let ingredientsLabel = UILabel.createDetailLabel()
    
    // Stack view to arrange all the labels vertically
    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, categoryLabel, instructionsLabel, ingredientsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    init(mealsManager: MealsManager, meal: Meal) {
        self.mealsManager = mealsManager
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
        
        setupManagerDelegates()
        fetchMealDetails()
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

// MARK: - Setup Methods
private extension MealDetailViewController {
    
    func setupManagerDelegates() {
        Task {
            await mealsManager.setDelegate(self)
        }
    }
    
    func fetchMealDetails() {
        Task {
            if let mealDetails = try await mealsManager.fetchDetailsForMeal(meal: meal) {
                await MainActor.run {
                    configureDetailsForMeal(with: mealDetails.meals[0])
                }
            }
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
        containerView.addSubview(imageView)
        containerView.addSubview(shimmerView)
        layoutViews()
    }
    
    func layoutViews() {
        view.addSubview(containerView)
        view.addSubview(scrollView)
        scrollView.addSubview(detailsStackView)
        
        let horizontalInset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            // Container View Constraints
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 250),
            
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // StackView Constraints
            detailsStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            detailsStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: horizontalInset),
            detailsStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -horizontalInset),
            detailsStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            detailsStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * horizontalInset)
        ])
        
        layoutShimmerView()
    }
}

// MARK: - View Update Methods
private extension MealDetailViewController {
    
    func updateView(for image: UIImage?) {
        if let thumbnailImage = image {
            imageView.image = thumbnailImage
            showImageView()
        } else {
            showShimmerView()
        }
        animateLayoutUpdate()
    }
    
    func showShimmerView() {
        imageView.isHidden = true
        shimmerView.isHidden = false
        layoutShimmerView()
    }
    
    func showImageView() {
        shimmerView.isHidden = true
        imageView.isHidden = false
        layoutImageView()
    }
    
    func layoutShimmerView() {
        NSLayoutConstraint.activate([
            shimmerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            shimmerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            shimmerView.heightAnchor.constraint(equalToConstant: 160),
            shimmerView.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 160),
            imageView.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    func animateLayoutUpdate() {
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Detail Configuration
private extension MealDetailViewController {
    
    func configureDetailsForMeal(with mealDetail: MealDetail) {
        nameLabel.text = mealDetail.strMeal
        categoryLabel.text = "\(mealDetail.strCategory) - \(mealDetail.strArea)"
        instructionsLabel.text = mealDetail.strInstructions
        
        let ingredients = [
            mealDetail.strIngredient1, mealDetail.strIngredient2, mealDetail.strIngredient3,
            mealDetail.strIngredient4, mealDetail.strIngredient5, mealDetail.strIngredient6,
            mealDetail.strIngredient7, mealDetail.strIngredient8, mealDetail.strIngredient9,
            mealDetail.strIngredient10, mealDetail.strIngredient11
        ].compactMap { $0?.isEmpty == true ? nil : $0 }
        
        ingredientsLabel.text = ingredients.joined(separator: ", ")
    }
}

// MARK: - MealsManagerDelegate
extension MealDetailViewController: MealsManagerDelegate {
    
    func didFetchMealThumbnail(_ mealThumbnail: MealThumbnail) {
        guard mealThumbnail.id == meal.idMeal else {
            print("This meal is not the one we are currently displaying.")
            return
        }
        updateView(for: mealThumbnail.image)
    }
}

// MARK: - UILabel Extension for Creating Detail Labels
private extension UILabel {
    static func createDetailLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
}

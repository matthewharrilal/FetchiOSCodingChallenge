//
//  MealDetailViewController.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/19/24.
//

import Foundation
import UIKit

class MealDetailViewController: UIViewController {
    private let mealsService: MealsProtocol
    private let meal: Meal
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = meal.thumbnailImage
        return imageView
    }()
    
    init(mealsService: MealsProtocol, meal: Meal) {
        self.mealsService = mealsService
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

private extension MealDetailViewController {
    
    func setup() {
        view.addSubview(imageView)
        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 88),
            imageView.widthAnchor.constraint(equalToConstant: 88)
        ])
    }
}

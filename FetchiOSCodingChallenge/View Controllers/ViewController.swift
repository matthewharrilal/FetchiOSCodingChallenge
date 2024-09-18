//
//  ViewController.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import UIKit

class MealsViewController: UIViewController {
    
    private let networkService: NetworkProtocol
    
    enum Constants {
        static let urlString: String = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    }
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
            do {
                if let meals: AllMeals = try await networkService.executeRequest(urlString: Constants.urlString) {
                    print(meals)
                } else {
                    print("No meals found")
                }
                
            }
            catch {
                print(error)
            }
        }
    }
}


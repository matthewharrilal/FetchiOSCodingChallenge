//
//  ViewController.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import UIKit

class MealsViewController: UIViewController {
    
    private let mealsService: MealsProtocol
    
    init(mealsService: MealsProtocol) {
        self.mealsService = mealsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        Task {
            try await mealsService.fetchMeals()
        }
    }
}


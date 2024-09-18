//
//  ViewController.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import UIKit

class MealsViewController: UIViewController {
    
    private let mealsService: MealsProtocol
        
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: MealTableViewCell.identifier)
        return tableView
    }()
    
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
        
        setup()
        
        Task {
            try await mealsService.fetchMeals()
        }
    }
}

private extension MealsViewController {
    
    func setup() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

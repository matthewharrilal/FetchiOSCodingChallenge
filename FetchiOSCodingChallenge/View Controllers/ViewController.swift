//
//  ViewController.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import UIKit

class MealsViewController: UIViewController {
    
    private let mealsService: MealsProtocol
    
    private var dataSource: UITableViewDiffableDataSource<Section, Meal>!
    
    private var meals: AllMeals = AllMeals(meals: []) {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private enum Section {
        case main
    }
        
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
        configureDataSource()
        fetchAllMeals()
    }
}

// MARK: UI/Setup Related Methods
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

// MARK: Data Source Related Methods
private extension MealsViewController {
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Meal>(tableView: tableView, cellProvider: { tableView, indexPath, meal in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.identifier, for: indexPath) as? MealTableViewCell else { return UITableViewCell() }
            
            cell.configure(meal: meal)
            return cell
        })
    }
    
    func fetchAllMeals() {
        Task {
            if let meals = try await mealsService.fetchMeals() {
                self.meals = meals
            }
            
            await MainActor.run {
                applySnapshot()
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Meal>()
        snapshot.appendSections([.main])
        
        // MARK: TODO Update Naming Here
        snapshot.appendItems(meals.meals)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

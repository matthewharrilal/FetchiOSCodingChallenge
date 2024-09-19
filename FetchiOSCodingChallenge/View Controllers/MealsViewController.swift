//
//  MealsViewController.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import UIKit

class MealsViewController: UIViewController {
    
    private let mealsService: MealsProtocol
    
    private var dataSource: UITableViewDiffableDataSource<Section, Meal>!
    
    // MARK: TODO Inject this
    // MARK: TODO This probably can have the meals service injected into it as well so that the view controller only talks to mealsManager
    private lazy var mealsManager = MealsManager()
    
    private var mealCollection: MealCollection = MealCollection(meals: [])
    
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
        fetchMealCollection()
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
    
    // MARK: TODO Explain Snapshot Issue
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Meal>(tableView: tableView, cellProvider: { tableView, indexPath, meal in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.identifier, for: indexPath) as? MealTableViewCell else { return UITableViewCell() }
            
            cell.configure(meal: meal)
            return cell
        })
    }
    
    func fetchMealCollection() {
        Task {
            if let mealCollection = try await mealsService.fetchMealCollection() {
                await mealsManager.setMeals(mealCollection.meals)
                self.mealCollection = await mealsManager.mealList
            }
            
            await MainActor.run {
                applySnapshot()
            }
            
            loadImagesForMeals()
        }
    }
    
    // MARK: TODO Explain Snapshot Issue
    func loadImagesForMeals() {
        Task {
            do {
                let mealWithImageStream = try await mealsService.fetchImagesForMealCollection(mealCollection: mealCollection)
                
                for try await mealWithImage in mealWithImageStream {
                    if let mealWithImage = mealWithImage, let index = mealCollection.meals.firstIndex(where: {$0.idMeal == mealWithImage.id}) {
                        await mealsManager.updateMeal(mealWithImage: mealWithImage, index: index)
                        
                        var snapshot = dataSource.snapshot()
                        snapshot.reloadItems([mealCollection.meals[index]])
                        
                        await MainActor.run {
                            dataSource.apply(snapshot, animatingDifferences: true)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Meal>()
        snapshot.appendSections([.main])
        
        // MARK: TODO Update Naming Here
        snapshot.appendItems(mealCollection.meals)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

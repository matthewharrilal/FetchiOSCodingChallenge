//
//  MealsViewController.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import UIKit

class MealsViewController: UIViewController {
    private let mealsManager: MealsManager
    
    private var dataSource: UITableViewDiffableDataSource<Section, Meal>!
    
    private var mealCollection: MealCollection = MealCollection(meals: [])
    
    private enum Section {
        case main
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: MealTableViewCell.identifier)
        tableView.delegate = self
        return tableView
    }()
    
    init(mealsManager: MealsManager) {
        self.mealsManager = mealsManager
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
            try await mealsManager.populateMealCollection()
            self.mealCollection = await mealsManager.mealList
            await applySnapshot()
            loadImagesForMeals()
        }
    }
    
    // MARK: TODO Explain Snapshot Issue
    func loadImagesForMeals() {
        Task {
            do {
                let mealThumbnailStream = try await mealsManager.populateImagesForMealCollection()
                
                for try await mealThumbnail in mealThumbnailStream {
                    guard
                        let mealThumnbail = mealThumbnail,
                        let index = mealCollection.meals.firstIndex(
                            where: {$0.idMeal == mealThumnbail.id}
                        )
                    else {
                        continue
                    }
                    
                    await mealsManager.updateMeal(
                        mealThumnbail: mealThumnbail,
                        index: index
                    )
                    
                    await reloadSnapshot(with: index)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func applySnapshot() async {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Meal>()
        snapshot.appendSections([.main])
        
        snapshot.appendItems(mealCollection.meals)
        
        await MainActor.run {
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func reloadSnapshot(with index: Int) async {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([mealCollection.meals[index]])
        
        await MainActor.run {
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: UITableView Delegate Methods
extension MealsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let meal = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let mealDetailViewController = MealDetailViewController(mealsManager: mealsManager, meal: meal)
        
        present(mealDetailViewController, animated: true)
    }
}

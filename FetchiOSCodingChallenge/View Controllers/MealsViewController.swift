//
//  MealsViewController.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import UIKit

/*
 IMPORTANT NOTE ON SNAPSHOT ISSUE

 Originally, the `Meal` model was a struct, and we were using it as the item identifier in our data source for the table view cells. The issue arose when we tried to update the `thumbnailImage` property of the `Meal` struct after asynchronously fetching the image. Since structs in Swift are value types, any modification to a `Meal` instance results in a new copy rather than updating the original instance held by the data source.

 This led to a problem: when the `thumbnailImage` was updated in the `mealCollection` array, the change didn’t propagate back to the data source because we were working with copies of the original `Meal` structs. The UI did not reflect the updated images, as the data source still had references to the original, unchanged structs.

 To resolve this, I changed `Meal` from a struct to a class. Classes are reference types, so changes to the `thumbnailImage` now affect the original instance directly, allowing the data source to display the updated images.

 However, this introduced a new potential issue: **race conditions**. Since the `thumbnailImage` is being updated asynchronously across multiple tasks, concurrent writes to the same `Meal` instance could lead to data inconsistencies or crashes. Classes, unlike structs, do not benefit from Swift’s automatic copy-on-write protection.

 To address this, I introduced `MealsManager` as an actor. Actors in Swift ensure that only one task can access or modify their state at a time, which prevents race conditions. By centralizing meal data updates inside the actor, we gain the safety of thread isolation without needing to manually manage locks or other synchronization primitives. This approach maintains the power of structured concurrency while ensuring safe updates to the `Meal` objects.

 ** TLDR **:
 - **Structs (Value Types)**: Changes didn’t propagate to the UI because updates were made to copies of the original `Meal` instances.
 - **Classes (Reference Types)**: Solved the propagation issue, but introduced the risk of race conditions.
 - **Actor (`MealsManager`)**: Prevents race conditions by isolating access to meal objects, ensuring safe concurrent updates.
 
 This architecture allows us to update the original meal instances safely while leveraging Swift's structured concurrency features.
 */

class MealsViewController: UIViewController {
    private let mealsManager: MealsManagerProtocol
    
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
    
    init(mealsManager: MealsManagerProtocol) {
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

// MARK: - Data Source Related Methods
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
    
    /**
     * Asynchronously loads images for all meals in the current collection.
     *
     *
     * This method fetches the meal thumbnail images asynchronously from `mealsManager` using an `AsyncThrowingStream`.
     * For each fetched image, the corresponding `Meal` object in `mealCollection` is updated, and the UITableView snapshot
     * is reloaded to reflect the new image.
     *
     */
    func loadImagesForMeals() {
        Task {
            do {
                let mealThumbnailStream = try await mealsManager.populateImagesForMealCollection()
                
                for try await mealThumbnail in mealThumbnailStream {
                    guard
                        let mealThumnbail = mealThumbnail,
                        let index = mealCollection.meals.firstIndex(
                            where: {$0.idMeal == mealThumnbail.id} // Find the original data source object that matches the id of the image we just fetched
                        )
                    else {
                        continue
                    }
                    
                    // Updating the original meal object (class object) inside an actor for the synchronzied serialized access that the actor model provides
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

// MARK: - UITableView Delegate Methods
extension MealsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let meal = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let mealDetailViewController = MealDetailViewController(mealsManager: mealsManager, meal: meal)
        present(mealDetailViewController, animated: true)
    }
}

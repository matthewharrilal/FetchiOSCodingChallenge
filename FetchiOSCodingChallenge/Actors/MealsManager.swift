//
//  MealManager.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/19/24.
//

import Foundation
import UIKit

// MARK: TODO Update Naming
// MARK: TODO Check if this is bad practice
@MainActor
protocol MealsManagerUpdateProtocol: AnyObject {
    func onMealThumbnailObtained(mealWithImage: MealThumbnail)
}

// MARK: TODO Explain use of Actor here
// MARK: TODO Abstract these methods to a protocol

actor MealsManager {
    private let mealsService: MealsProtocol
    private var mealCollection: MealCollection = MealCollection(meals: [])
        
    private weak var delegate: MealsManagerUpdateProtocol?
    
    public var mealList: MealCollection {
        self.mealCollection
    }
    
    init(mealsService: MealsProtocol) {
        self.mealsService = mealsService
    }
    
    public func mealFor(index: Int) -> Meal? {
        guard index < mealList.meals.count else {
            return nil
        }

        return mealList.meals[index]
    }
    
    public func setMeals(_ newMeals: [Meal]) {
        mealCollection.meals = newMeals
    }
    
    public func updateMeal(mealWithImage: MealThumbnail, index: Int) async {
        mealCollection.meals[index].thumbnailImage = mealWithImage.image
        
        // MARK: TODO on why we made the method async and check if using delegates inside of an actor even if it works is bad practice
        await delegate?.onMealThumbnailObtained(mealWithImage: mealWithImage)
    }
    
    public func populateMealCollection() async throws {
        if let mealsCollection = try await mealsService.fetchMealCollection() {
            setMeals(mealsCollection.meals)
        }
    }
    
    public func populateImagesForMealCollection() async throws -> AsyncThrowingStream<MealThumbnail?, Error> {
        do {
            return try await mealsService.fetchImagesForMealCollection(mealCollection: mealList)
        }
        catch {
            throw error
        }
    }
    
    // MARK: TODO Add documentation
    public func setDelegate(_ conformer: MealsManagerUpdateProtocol) {
        delegate = conformer
    }
}

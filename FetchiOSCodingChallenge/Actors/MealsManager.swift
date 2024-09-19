//
//  MealManager.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/19/24.
//

import Foundation

// MARK: TODO Explain use of Actor here
actor MealsManager {
    private var mealCollection: MealCollection = MealCollection(meals: [])
    
    public var mealList: MealCollection {
        self.mealCollection
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
    
    public func updateMeal(mealWithImage: MealThumbnail, index: Int) {
        mealCollection.meals[index].thumbnailImage = mealWithImage.image
    }
}

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
    
    func setMeals(_ newMeals: [Meal]) {
        mealCollection.meals = newMeals
    }
    
    func updateMeal(mealWithImage: MealThumbnail, index: Int) {
        mealCollection.meals[index].thumbnailImage = mealWithImage.image
    }
}

//
//  MealManager.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/19/24.
//

import Foundation

actor MealsManager {
    private var meals: AllMeals = AllMeals(meals: [])
    
    public var currentMeals: AllMeals {
        self.meals
    }
    
    func setMeals(_ newMeals: [Meal]) {
        meals.meals = newMeals
    }
    
    func updateMeal(mealWithImage: MealWithImage, index: Int) {
        meals.meals[index].thumbnailImage = mealWithImage.image
    }
}

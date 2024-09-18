//
//  Meals.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation

struct AllMeals: Decodable {
    let meals: [Meal]
}

struct Meal: Decodable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

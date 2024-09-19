//
//  MealDetail.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/19/24.
//

import Foundation

struct MealDetails: Decodable {
    let meals: [MealDetail]
}

struct MealDetail: Decodable {
    let idMeal: String
    let strMeal: String
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strIngredient1: String
    let strIngredient2: String
    let strIngredient3: String
    let strIngredient4: String
    let strIngredient5: String
    let strIngredient6: String
    let strIngredient7: String
    let strIngredient8: String
    let strIngredient9: String
    let strIngredient10: String
    let strIngredient11: String
}

//
//  Meals.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation
import UIKit

struct MealCollection: Decodable, Hashable {
    // `meals` is mutable because we need to update the array after alphabetizing it.
    var meals: [Meal]
}

/* `Meal` is a class to ensure reference-based updates, allowing changes to
   propagate to the original instance, which solves the issue of structs (value types)
   creating copies when modified. Using an actor (`MealsManager`) ensures
   thread-safe updates to the `thumbnailImage` property during asynchronous image fetching.
 */
class Meal: Decodable, Hashable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    var thumbnailImage: UIImage? = nil
    
    // Adding these coding keys explicitly to ignore thumbnail image during decoding process
    enum CodingKeys: String, CodingKey {
        case strMeal
        case strMealThumb
        case idMeal
    }
    
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.idMeal == rhs.idMeal // Only compare the unique identifier, not the image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(idMeal) // Only hash the unique identifier
    }
}

struct MealThumbnail {
    let id: String
    let image: UIImage
}

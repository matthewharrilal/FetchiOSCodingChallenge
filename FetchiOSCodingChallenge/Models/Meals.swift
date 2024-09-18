//
//  Meals.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation
import UIKit

struct AllMeals: Decodable, Hashable {
    let meals: [Meal]
}

struct Meal: Decodable, Hashable {
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
}

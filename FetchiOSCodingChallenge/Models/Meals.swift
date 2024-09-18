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
}

struct AggregatedMeal {
    let title: String
    let description: String
    
    var thumbnailImage: UIImage?
}

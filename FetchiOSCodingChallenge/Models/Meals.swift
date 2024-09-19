//
//  Meals.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation
import UIKit

struct MealCollection: Decodable, Hashable {
    var meals: [Meal] // MARK: TODO Explain why this was made a var
}

// MARK: TODO Explain why this was made a class
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

class MealThumbnail {
    let id: String
    let image: UIImage
    
    init(id: String, image: UIImage) {
        self.id = id
        self.image = image
    }
}

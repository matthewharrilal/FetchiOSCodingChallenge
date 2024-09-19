//
//  MealCollection.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/19/24.
//

import Foundation

struct MealCollection: Decodable, Hashable {
    // `meals` is mutable because we need to update the array after alphabetizing it.
    var meals: [Meal]
}

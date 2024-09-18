//
//  MealsService.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation

protocol MealsProtocol {
    func fetchMeals() async throws -> AllMeals?
}

struct MealsService: MealsProtocol {
    
    private let networkService: NetworkProtocol
    
    enum Constants {
        static let urlString: String = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    }
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
    
    func fetchMeals() async throws -> AllMeals? {
        do {
            if let meals: AllMeals = try await networkService.executeRequest(urlString: Constants.urlString) {
                return meals
            } else {
                print("No meals found")
                return nil
            }
            
        }
        catch {
            print(error)
            return nil
        }
    }
}

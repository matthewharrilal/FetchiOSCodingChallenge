//
//  MealsService.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/18/24.
//

import Foundation

protocol MealsProtocol {
    func fetchMealCollection() async throws -> MealCollection?
    func fetchImagesForMealCollection(mealCollection: MealCollection) async throws -> AsyncThrowingStream<MealThumbnail?, Error>
}

struct MealsService: MealsProtocol {
    
    private let networkService: NetworkProtocol
    
    enum Constants {
        static let mealCollectionURLString: String = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    }
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
    
    func fetchMealCollection() async throws -> MealCollection? {
        do {
            if let mealCollection: MealCollection = try await networkService.executeRequest(urlString: Constants.mealCollectionURLString) {
                return mealCollection
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
    
    // MARK: TODO Break this method up
    // MARK: TODO Add documentation
    // MARK: TODO Ensure proper error handling and throwing of errors 
    func fetchImagesForMealCollection(mealCollection: MealCollection) async throws -> AsyncThrowingStream<MealThumbnail?, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    try await withThrowingTaskGroup(of: MealThumbnail?.self) { taskGroup in
                        for meal in mealCollection.meals {
                            taskGroup.addTask {
                                do {
                                    if let image = try await networkService.fetchImage(urlString: meal.strMealThumb) {
                                        return MealThumbnail(id: meal.idMeal, image: image)
                                    } else {
                                        return nil
                                    }
                                }
                                catch {
                                    throw error
                                }
                            }
                            
                        }
                        
                        for try await mealWithImage in taskGroup {
                            continuation.yield(mealWithImage)
                            
                        }
                        
                        continuation.finish()
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
                
            }
        }
    }
}

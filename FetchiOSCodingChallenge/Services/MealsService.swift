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
    
    /**
     * Goal: Fetches a collection of meals from the network, sorts them alphabetically by name, and returns the collection.
     *
     * Parameters:
     * - None
     *
     * Return:
     * An optional `MealCollection` that contains an alphabetically sorted list of meals. If the request fails or no meals are found, it returns `nil`.
     *
     * This method fetches the meal collection using the provided `networkService` and sorts the `meals` array in the `MealCollection` based on the meal names.
     *
     */
    func fetchMealCollection() async throws -> MealCollection? {
        do {
            if var mealCollection: MealCollection = try await networkService.executeRequest(urlString: Constants.mealCollectionURLString) {
                mealCollection.meals = mealCollection.meals.sorted { $0.strMeal.lowercased() < $1.strMeal.lowercased() }
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
    
    /**
     * Goal: Fetches images for a collection of meals asynchronously and returns them as an `AsyncThrowingStream`.
     *
     * Parameters:
     * - mealCollection: A collection of `Meal` objects containing image URLs that need to be fetched
     *
     * Return:
     * An `AsyncThrowingStream` that yields `MealThumbnail?` values asynchronously. Each value contains
     * the meal's ID and its corresponding image, or `nil` if the image fetch fails.
     */
    func fetchImagesForMealCollection(mealCollection: MealCollection) async throws -> AsyncThrowingStream<MealThumbnail?, Error> {
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    try await createTaskGroupForMealThumbnail(mealCollection: mealCollection, continuation: continuation)
                }
                catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

private extension MealsService {
    
    /**
     * Goal: Creates a `ThrowingTaskGroup` that processes a collection of meals, fetching images asynchronously,
     * and yields the results to the provided continuation for an `AsyncThrowingStream`.
     *
     * Parameters:
     * - mealCollection: A collection of `Meal` objects for which images need to be fetched.
     * - continuation: The continuation object provided by the async stream, allowing values to be yielded back
     *   to the stream as images are fetched.
     *
     * Return:
     * This method does not return a value. It manages the lifecycle of tasks inside the task group, and the task
     * group is deallocated once all tasks are completed.
     */
    func createTaskGroupForMealThumbnail(mealCollection: MealCollection, continuation: AsyncThrowingStream<MealThumbnail?, Error>.Continuation) async throws {
        
        try await withThrowingTaskGroup(of: MealThumbnail?.self) { taskGroup in
            for meal in mealCollection.meals {
                taskGroup.addTask {
                    try await fetchMealThumbnail(with: meal)
                }
            }
            
            for try await mealWithImage in taskGroup {
                continuation.yield(mealWithImage)
            }
            
            continuation.finish()
        }
    }
    
    
    /**
     * Goal: Fetches the thumbnail image for a specific meal asynchronously.
     *
     * Parameters:
     * - meal: The `Meal` object for which the thumbnail image needs to be fetched.
     *
     * Return:
     * A `MealThumbnail?` containing the meal's ID and the fetched image. Returns `nil` if the image could not be retrieved.
     */
    func fetchMealThumbnail(with meal: Meal) async throws -> MealThumbnail? {
        if let image = try await networkService.downloadImage(urlString: meal.strMealThumb) {
            return MealThumbnail(id: meal.idMeal, image: image)
        } else {
            return nil
        }
    }
}

//
//  MealsManager.swift
//  FetchiOSCodingChallenge
//
//  Created by Space Wizard on 9/19/24.
//

import Foundation
import UIKit

/**
 * This protocol lets you know when meal thumbnails have been fetched.
 *
 * When the `MealsManager` grabs a thumbnail image for a meal, it will notify the delegate through this method.
 * The `@MainActor` attribute makes sure that everything runs on the main thread, so it's safe for UI updates.
 *
 * - Note: Any class that adopts this protocol should be ready for multithreading, especially if it’s updating the UI.
 */
@MainActor
protocol MealsManagerDelegate: AnyObject {
    func didFetchMealThumbnail(_ mealThumbnail: MealThumbnail)
}

protocol MealsManagerProtocol: Actor {
    var mealList: MealCollection { get }
    
    func mealFor(index: Int) -> Meal?
    func setMeals(_ newMeals: [Meal])
    func updateMeal(mealThumnbail: MealThumbnail, index: Int) async
    func populateMealCollection() async throws
    func fetchDetailsForMeal(meal: Meal) async throws -> MealDetails?
    func populateImagesForMealCollection() async throws -> AsyncThrowingStream<MealThumbnail?, Error>
    func setDelegate(_ conformer: MealsManagerDelegate)
}

// MARK: TODO Abstract these methods to a protocol

actor MealsManagerImplementation: MealsManagerProtocol {
    private let mealsService: MealsProtocol
    private var mealCollection: MealCollection = MealCollection(meals: [])
        
    private weak var delegate: MealsManagerDelegate?
    
    public var mealList: MealCollection {
        self.mealCollection
    }
    
    init(mealsService: MealsProtocol) {
        self.mealsService = mealsService
    }
    
    public func mealFor(index: Int) -> Meal? {
        guard index < mealList.meals.count else {
            return nil
        }

        return mealList.meals[index]
    }
    
    public func setMeals(_ newMeals: [Meal]) {
        mealCollection.meals = newMeals
    }
    
    /**
     * Updates the thumbnail image of a meal at the specified index and notifies the delegate asynchronously.
     *
     * Parameters:
     * - mealWithImage: A `MealThumbnail` containing the updated thumbnail image for the meal.
     * - index: The index of the meal to update.
     *
     * This method also notifies the delegate via the `onMealThumbnailObtained` method.
     */
    public func updateMeal(mealThumnbail: MealThumbnail, index: Int) async {
        mealCollection.meals[index].thumbnailImage = mealThumnbail.image
        
        // MARK: TODO on why we made the method async and check if using delegates inside of an actor even if it works is bad practice
        await delegate?.didFetchMealThumbnail(mealThumnbail)
    }
    
    public func populateMealCollection() async throws {
        if let mealsCollection = try await mealsService.fetchMealCollection() {
            setMeals(mealsCollection.meals)
        }
    }
    
    public func fetchDetailsForMeal(meal: Meal) async throws -> MealDetails? {
        return try await mealsService.fetchDetailsForMeal(meal: meal)
    }
    
    /**
     * Asynchronously fetches images for the current meal collection and returns them as an `AsyncThrowingStream`.
     *
     * Return:
     * An `AsyncThrowingStream` that yields `MealThumbnail?` values as the images are fetched.
     *
     * Throws:
     * An error if the image fetching fails.
     */
    public func populateImagesForMealCollection() async throws -> AsyncThrowingStream<MealThumbnail?, Error> {
        do {
            return try await mealsService.fetchImagesForMealCollection(mealCollection: mealList)
        }
        catch {
            throw error
        }
    }
    
    /**
     * - Goal - Sets the delegate to receive updates on meal thumbnail fetching.
     *
     * - Reasoning - We can't set the delegate outside of the actor's isolated context so have to pass the instance of the conformer back to actor's isolated context to set connection
     *
     * Parameters:
     * - conformer: An object conforming to `MealsManagerUpdateProtocol` that will receive updates.
     */
    public func setDelegate(_ conformer: MealsManagerDelegate) {
        delegate = conformer
    }
}

# Recipe Explorer - iOS Coding Challenge

## Overview
Recipe Explorer is an iOS app that allows users to browse and explore dessert recipes fetched from TheMealDB API. Users can view details such as the name, thumbnail image, cooking instructions, and ingredients.

The app leverages **Swift Concurrency (async/await)** for efficient asynchronous API calls and **custom Actors** to serialize in a concurrent environment.

## Features
- Browse a list of dessert meals from TheMealDB API.
- View detailed meal info: thumbnail, name, instructions, and ingredients.
- Alphabetically sorted meal list.
- Filters out null/empty values for clean UI.

## API Endpoints
- **Dessert Meals List**: [TheMealDB API](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert)
- **Meal Details**: [TheMealDB API](https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID)

## Requirements
- Xcode (latest version)
- iOS 14.0+
- Swift 5.5+

## Installation
```bash
git clone https://github.com/yourusername/FetchiOSCodingChallenge.git
cd FetchiOSCodingChallenge
open FetchiOSCodingChallenge.xcodeproj
```

## Project Structure

```
|-- Models/
|   |-- Meal.swift
|   |-- MealCollection.swift
|   |-- MealDetails.swift
|   |-- MealThumbnail.swift
|
|-- Services/
|   |-- MealsService.swift
|   |-- NetworkService.swift
|
|-- Actors/
|   |-- MealsManager.swift
|
|-- ViewControllers/
|   |-- MealsViewController.swift
|   |-- MealDetailViewController.swift
|
|-- Views/
|   |-- MealTableViewCell.swift
|   |-- ShimmerView.swift
|
|-- Utilities/
|   |-- UILabel+Extensions.swift
```

- **Models/**: Defines `Meal`, `MealCollection`, `MealDetails`, and `MealThumbnail` for managing meal data.
- **Services/**: Handles network requests using `MealsService` and `NetworkService` for fetching data from TheMealDB API.
- **Actors/**: `MealsManager` actor manages safe concurrent access to meals and handles updates.
- **ViewControllers/**: `MealsViewController` displays the meal list, while `MealDetailViewController` handles meal details.
- **Views/**: Custom `UITableViewCell` for meal display and `ShimmerView` for loading states.
- **Utilities/**: Contains extensions and helper methods, like styled label creation.

## Architecture & Patterns
- **MVC**: Clear separation of data, UI, and logic.
- **Swift Concurrency**: `async/await` for asynchronous operations.
- **Actors**: Safely manage meal state and prevent race conditions.
- **Diffable Data Source**: Efficient updates in `UITableView`.

## Future Improvements
- Offline caching of meals and images.
- Add search functionality to explore more categories.
- UI improvements and shimmer effects for loading.
- Comprehensive unit tests.

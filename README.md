# Recipe Explorer - iOS Coding Challenge

## Overview
This iOS application allows users to browse and explore dessert recipes using data fetched from TheMealDB API. Users can select a dessert to view details, including the meal name, instructions, and a list of ingredients with measurements.

The app is built using **Swift Concurrency (async/await)** for efficient and smooth handling of asynchronous API calls and the usage of **custom Actors**.

## Features
- Displays a list of dessert meals fetched from TheMealDB API.
- Alphabetically sorted list of meals in the Dessert category.
- Detailed meal view, including:
  - Meal thumbnail image
  - Meal name
  - Cooking instructions
  - Ingredients with measurements
- Filters out null or empty values from the API to ensure clean data display.

## API Endpoints
- **Dessert Meals List**: Fetches the list of meals in the Dessert category.
  - URL: `https://themealdb.com/api/json/v1/1/filter.php?c=Dessert`
- **Meal Details**: Fetches detailed information for a specific meal by its ID.
  - URL: `https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID`

## Requirements
- Xcode (latest version)
- iOS 14.0+
- Swift 5.5+

## Installation
1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/FetchiOSCodingChallenge.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd FetchiOSCodingChallenge
   ```

3. **Open the project in Xcode:**
   ```bash
   open FetchiOSCodingChallenge.xcodeproj
   ```

4. **Build and run** the app in the simulator or on a physical device.

## Architecture & Design Patterns
- **MVC (Model-View-Controller)**: Provides a clear separation of concerns between data, UI, and business logic.
- **Swift Concurrency**: All asynchronous operations are handled using `async/await` for cleaner and more efficient code and usage of `custom Actors`.
- **Diffable Data Source**: Used to handle updates in the table view efficiently when fetching meal data.

## Future Improvements
- Add offline caching of meals and recipes.
- Implement a search feature to explore other recipe categories.
- Improve the user interface with custom designs and animations.
- Prefetch items in SceneDelegate before initial showing of meals.
- Add shimmer view for Meal Detail text.
- Add more comprehensive testing. 

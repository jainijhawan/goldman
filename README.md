# Goldman Sachs iOS Codeing Challenge

This is a brief about the iOS Project 

 - The app gets Weather data according to the User's Location and display it in the first Screen
 - The user can search city and Google's AutoComplete API is used for suggestions 
 - The User can save the Cities to My Places and city Name will be persisted and data For that city will be displayed in the Bottom of the first screen

# The app uses MVVM and Clean Architecture
 
## Screens

> **Each Screen has an Interactor which acts as layer between ViewModel and Services**
> **Interactor can have Multiple Services which ViewModel is unaware of**

 1. **CurrentLocationViewController** - It shows data for current location and weather data for all the cities in My Places
 2. **SearchLocationViewController** - It shows search results from user input by AutoComplete API from which user can get the data for selected city
 3. **CityDetailViewController** - It shows data about the selected city by user and gives functionality to save it to the database

## Services

 1.  **PersistenceService** - This service provides core data persistence functionality. It saves and fetches data from core data.
 2. **CityWeatherService** - This service provide weather data for a particular city name.
 3. **SearchCityLocationService** - This service provide auto-complete search results from Google Places API
 4. **CurrentLocationService** - This service provide weather data for particular Latitude and Longitude 
 5. **NetworkService** - This is the Network Layer which does GET call for particular URL provided by Service

## Other Helper Classes

 - **AppHeler** - It provide static functions like reverseGeoCode and getImageForCurrentWeatherID
 - **URLGenerator ** -  It provides URL for different services
 - **PathGenerator** - It is an API Path Generator File
 - **Extensions** - It holds the extensions of different data types

# One Important Flow
If user taps save to my places after saving data to Core Data by **persistentContainer.viewContext** a Notification is fired which is observed by **CurrentLocationInteractor** which fires a closure **onDatabaseUpdate** which is subscribed   by **CurrentLocationViewModel** which appends the new saved city to **savedCitiesDataModel** and reload the cityCollectionView in **CurrentLocationViewController**
 
# The app only saves city name in my places so if you try to save Delhi which is Canada it will show data for Delhi India only and currently there is no way to delete saved Cities

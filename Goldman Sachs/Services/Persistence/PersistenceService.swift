//
//  PersistenceService.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//

import Foundation
import CoreData

protocol PersistenceServiceType {
  func saveCity(name: String)
  func getPersistanceContainer() -> NSManagedObjectContext
  func getAllSavedCities() -> [City]
}

class PersistenceService: PersistenceServiceType {
    
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Goldman Sachs")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  private func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func saveCity(name: String) {
    let managedContext = persistentContainer.viewContext
    let entity = City(context: managedContext)
    entity.name = name
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
    }
    NotificationCenter.default.post(name: .onDatabaseUpdate, object: nil)
  }
  
  func getAllSavedCities() -> [City]  {
    var cities  = [City]()
    let fetchRequest = NSFetchRequest<City>(entityName: "City")
    do {
      let fetchedResults = try persistentContainer.viewContext.fetch(fetchRequest)
      cities = fetchedResults
    } catch let error as NSError {
      print(error.description)
    }
    return cities
  }
  
  func getPersistanceContainer() -> NSManagedObjectContext {
    return persistentContainer.viewContext
  }
}

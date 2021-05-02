//
//  City+CoreDataProperties.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?

}

extension City : Identifiable {

}

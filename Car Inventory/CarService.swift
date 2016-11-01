//
//  CarService.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 9/3/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import Foundation
import CoreData

class CarService {
    //
    var managedObjectContext: NSManagedObjectContext!
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getCarInventory() -> [Car] {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.fetchBatchSize = 15
        let results: [Car]
        
        do {
            results = try managedObjectContext.fetch(request)
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results
    }
    
    func getTotalCarInInventorySlow() -> Int {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        let results: [Car]
        
        do {
            results = try managedObjectContext.fetch(request)
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results.count
    }
    
    func getTotalSUVbyPriceSlow() -> Int {
        let predicate = NSPredicate(format: "specs.type == 'suv' && price <= 30000")
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.predicate = predicate
        
        let results: [Car]
        
        do {
            results = try managedObjectContext.fetch(request)
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results.count
    }
    
    func getInventory(_ price: Int, condition: Int, type: String) -> [Car] {
        let pricePredicate = NSPredicate(format: "price <= %@", NSNumber(value: price))
        let conditionPredicate = NSPredicate(format: "specs.conditionRating >= %@", NSNumber(value: condition))
        
        var predicateArray = [pricePredicate, conditionPredicate]
        
        let carTypePredicate = type != "all" ? NSPredicate(format: "specs.type == %@", type) : NSPredicate()
        
        if carTypePredicate is NSComparisonPredicate {
            predicateArray.append(carTypePredicate)
        }
        
        let predicate = NSCompoundPredicate(type: .and, subpredicates: predicateArray)
        
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.predicate = predicate
        request.fetchBatchSize = 16
        
        let results: [Car]
        
        do {
            results = try managedObjectContext.fetch(request)
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return results
    }
    
    func getCarTypes() -> [String] {
        let request: NSFetchRequest<Specification> = Specification.fetchRequest()
        
        var results: [Specification]
        var carTypes = ["all"]
        
        do {
            results = try managedObjectContext.fetch(request)
            for spec in results {
                if !carTypes.contains(spec.type!) {
                    carTypes.append(spec.type!)
                }
            }
        }
        catch {
            fatalError("Error getting list of car types from inventory")
        }
        
        return carTypes
    }
}

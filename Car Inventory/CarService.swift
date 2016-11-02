//
//  CarService.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 9/3/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import Foundation
import CoreData

public class CarService {
    
    public var managedObjectContext: NSManagedObjectContext!
    
    public init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getCarInventory() -> [Car] {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
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
    
    
    public func getTotalCarInInventory() -> Int {
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
    
    public func getTotalCarInInventory_UPDATED() -> Int {
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.resultType = .countResultType
        do {
            let results = try managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [NSNumber]
            let count = results.first!.intValue
            return count
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
        return 0
    }
    
    public func getTotalSUVbyPrice() -> Int {
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
    
    public func getTotalSUVbyPrice_UPDATED() -> Int {
        let predicate = NSPredicate(format: "specs.type == 'suv' && price <= 30000")
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        request.predicate = predicate
        
        let results: [Car]
        
        do {
            let results = try managedObjectContext.count(for: request)
            return results
        }
        catch {
            fatalError("Error getting car inventory")
        }
        
    }
    
    public func getInventory(_ price: Int, condition: Int, type: String) -> [Car] {
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
    
    public func getInventory_UPDATED(_ price: Int, condition: Int, type: String) -> [Car] {
        var predicateArray = [NSPredicate]()
        let carTypePredicate = type != "all" ? NSPredicate(format: "specs.type == %@", type) : NSPredicate()
        
        if carTypePredicate is NSComparisonPredicate {
            predicateArray.append(carTypePredicate)
        }
        
        let pricePredicate = NSPredicate(format: "price <= %@", NSNumber(value: price))
        predicateArray.append(carTypePredicate)
        
        let conditionPredicate = NSPredicate(format: "specs.conditionRating >= %@", NSNumber(value: condition))
        predicateArray.append(conditionPredicate)
        
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
    

    public func getCarTypes() -> [String] {
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
    
    public func getCarTypes_UPDATED() -> [String] {
        let request: NSFetchRequest<Specification> = Specification.fetchRequest()
        request.propertiesToFetch = ["type"]
        request.returnsDistinctResults = true
        request.resultType = .dictionaryResultType
        
        var results: [[String:String]]
        var carTypes = ["all"]
        
        do {
            results = try managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [[String:String]]
            for spec in results {
                carTypes.append(spec["type"]!)
            }
        }
        catch {
            fatalError("Error getting list of car types from inventory")
        }
        
        return carTypes
    }
}

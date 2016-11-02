//
//  Car_InventoryTests.swift
//  Car InventoryTests
//
//  Created by Sunny on 2016/11/2.
//  Copyright © 2016年 devhubs. All rights reserved.
//

import XCTest
import Car_Inventory

class Car_InventoryTests: XCTestCase {
    
    var carService: CarService!
    var coreData: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreData = CoreDataStack()
        carService = CarService(managedObjectContext: coreData.persistentContainer.viewContext)
        
        carService.managedObjectContext = coreData.persistentContainer.viewContext
        carService.managedObjectContext.stalenessInterval = 0.0
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    func testGetTotalCarInInventory(){
        self.measure {
            _ = self.carService.getTotalCarInInventory()
        }
    }
    
    func testGetTotalCarInInventory_UPDATED(){
        self.measure {
            _ = self.carService.getTotalCarInInventory_UPDATED()
        }
    }
 */
    /*
    func testGetTotalSUVbyPrice(){
        self.measure {
            _ = self.carService.getTotalSUVbyPrice()
        }
    }

    func testGetTotalSUVbyPrice_UPDATED(){
        self.measure {
            _ = self.carService.getTotalSUVbyPrice_UPDATED()
        }
    }
 */
    /*
    func testGetInventory(){
        self.measure {
            _ = self.carService.getInventory(30000, condition: 8, type: "nil")
        }
    }

    func testGetInventory_UPDATED(){
        self.measure {
            _ = self.carService.getInventory_UPDATED(30000, condition: 8, type: "nil")
        }
    }
 */
    func testGetCarTypes(){
        self.measure{
            _ = self.carService.getCarTypes()
        }
    }

    func testGetCarTypes_UPDATED(){
        self.measure{
            _ = self.carService.getCarTypes_UPDATED()
        }
    }
}

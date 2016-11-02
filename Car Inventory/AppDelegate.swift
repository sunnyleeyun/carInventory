//
//  AppDelegate.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 9/3/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coreData = CoreDataStack()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navController = self.window?.rootViewController as! UINavigationController
        let inventoryController = navController.topViewController as! InventoryCollectionViewController
        inventoryController.managedObjectContext = coreData.persistentContainer.viewContext
        
        checkDataStore()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        coreData.saveContext()
    }
    
    func checkDataStore() {
        let managedObjectContext = coreData.persistentContainer.viewContext
        let request: NSFetchRequest<Car> = Car.fetchRequest()
        
        do {
            let carsCount = try managedObjectContext.count(for: request)
            print("Total cars: \(carsCount)")
            
            if carsCount == 0 {
                uploadSampleData()
            }
        }
        catch {
            fatalError("Fail to count car inventory")
        }
    }
    
    func uploadSampleData() {
        let managedObjectContext = coreData.persistentContainer.viewContext
        let url = Bundle.main.url(forResource: "cars", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            let jsonArray = jsonResult.value(forKey: "inventory") as! NSArray
            
            for data in jsonArray {
                let json = data as! [String: AnyObject]
                let car = Car(context: managedObjectContext)
                
                guard let make = json["make"] else {
                    return
                }
                
                guard let model = json["model"] else {
                    return
                }
                
                guard let year = json["year"] else {
                    return
                }
                
                guard let price = (json["values"] as! [String: AnyObject])["price"] else {
                    return
                }
                
                car.make = make as? String
                car.model = model as? String
                car.year = year.int32Value
                car.price = price as! Double
                
                let imageName = String(car.year) + car.make! + car.model! + ".jpg"
                let image = resizeImage(image: UIImage(named: imageName)!, newWidth: 200)
                let carData = UIImageJPEGRepresentation(image, 1)
                car.thumbnail = NSData.init(data: carData!)
                
                let carImage = CarImage(context: managedObjectContext)
                let originalImage = UIImage(named: imageName)
                let originalImageData = UIImageJPEGRepresentation(originalImage!, 1)
                carImage.image = NSData.init(data: originalImageData!)
                
                car.carImage = carImage
                
                let specs = Specification(context: managedObjectContext)
                specs.conditionRating = ((json["values"] as! [String: AnyObject])["condition"]?.int16Value)!
                specs.avgFuel = ((json["values"] as! [String: AnyObject])["fuel_eff"]?.int16Value)!
                specs.horsepower = ((json["values"] as! [String: AnyObject])["horsepower"]?.int16Value)!
                specs.type = json["type"] as? String
                
                let safetyRating = (json["values"] as! [String: AnyObject])["safety"]
                let safetyRatingNumber = safetyRating! as! String == "NA" ? "10.0" : safetyRating as! String
                specs.safetyRating = Double(safetyRatingNumber)!
                
                car.specs = specs
            }
            
            coreData.saveContext()
            
            let request: NSFetchRequest<Car> = Car.fetchRequest()
            let carsCount = try? managedObjectContext.count(for: request)
            print("Total cars: \(carsCount)")
        }
        catch {
            fatalError("Cannot upload sample data")
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


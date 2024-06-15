//
//  LocalDatabase.swift
//  ShelfLife
//
//  Created by Dev User1 on 6/30/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import Foundation
import SQLite3

class LocalDatabase {
    
    let tableLocationCategory = "location_category"
    let tableLocation = "location"
    let tableFood = "food"

    let dbPath: String = "myDb.sqlite"
    var db: OpaquePointer?
    
    init() {
        self.db = self.openDatabase()
                
        //self.deleteTable(tableName: "food")
        
        var tableExists = self.checkTableExists(tableName: self.tableLocationCategory)
        if !tableExists {
            self.createTable(tableName: self.tableLocationCategory)
            self.fillTableLocationCategory()
        }
        
        tableExists = self.checkTableExists(tableName: self.tableLocation)
        if !tableExists {
            self.createTable(tableName: self.tableLocation)
            self.fillTableLocation()
        }
        
        tableExists = self.checkTableExists(tableName: self.tableFood)
        if !tableExists {
            self.createTable(tableName: self.tableFood)
        }
        
        //print(self.daysTillExpiration(expirationDate: "07/18/2021"))
        
        
//        self.deleteTable(tableName: self.tableLocationCategory)
//        self.deleteTable(tableName: self.tableLocation)
//        self.deleteTable(tableName: self.tableFood)

    }
    
    func getRowCount(tableName: String) {
        
        let getRowCountString = "SELECT COUNT(*) FROM \(tableName)"
        var getRowQuery: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, getRowCountString, -1, &getRowQuery, nil) == SQLITE_OK {
            
            while sqlite3_step(getRowQuery) == SQLITE_ROW {
                let count = Int(sqlite3_column_int(getRowQuery, 0))
                print("count: \(count)")
            }
            
        }
        
    }
    
    func openDatabase() -> OpaquePointer? {
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
        
    }
    
    func checkTableExists(tableName: String) -> Bool {
        
        let checkTableExistsString = "SELECT name FROM sqlite_master WHERE type='table' AND name = '\(tableName)'"
        var checkTableExistsQuery: OpaquePointer? = nil
        
        var tableNamesList: [String] = []
        
        if sqlite3_prepare_v2(self.db, checkTableExistsString, -1, &checkTableExistsQuery, nil) ==  SQLITE_OK {
            
            while sqlite3_step(checkTableExistsQuery) == SQLITE_ROW {
                let storageName = String(describing: String(cString: sqlite3_column_text(checkTableExistsQuery, 0)))
                tableNamesList.append(storageName)
            }
            
            print("\(tableName) Table Checked")
            
        } else {
            print("Could not check \(tableName) table")
        }
        
        if tableNamesList.count == 0 {
            return false
        } else {
            return true
        }
        
    }
    
    func createTable(tableName: String) {
        var createTableString = ""
        switch tableName {
        case "location_category":
            createTableString = "CREATE TABLE IF NOT EXISTS location_category(location_category_id INTEGER PRIMARY KEY AUTOINCREMENT, location_category_name TEXT NOT NULL, display_order INTEGER);"
            break
        case "location":
            createTableString = "CREATE TABLE IF NOT EXISTS location(location_id INTEGER PRIMARY KEY AUTOINCREMENT,  location_category_id INTEGER, location_name TEXT NOT NULL, display_order INTEGER);"
            break
        case "food":
            createTableString = "CREATE TABLE IF NOT EXISTS food(food_id INTEGER PRIMARY KEY AUTOINCREMENT, location_id INTEGER, food_name TEXT NOT NULL, expiration_date TEXT NOT NULL, tags TEXT NOT NULL, quantity INTEGER);"
        default:
            break
        }
        
        var returnValue = self.executeCreateTable(createTableString: createTableString)
        //if !returnValue
        
    }
    
    func executeCreateTable(createTableString: String) -> Bool {
    
        var returnValue = false
        var createTableQuery: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableQuery, nil) == SQLITE_OK {
            
            if sqlite3_step(createTableQuery) == SQLITE_DONE {
                print("Table Created")
                returnValue = true
            } else {
                print("Table Could Not Be Created")
                returnValue = false
            }
            
        } else {
            print("CREATE TABLE statement could not be prepared")
        }
        
        return returnValue
        
    }
    
    func insertRowLocationCategory(locationCategoryID: Int, locationCategoryName: String, displayOrder: Int) {
        
        let insertString = "INSERT INTO location_category (location_category_id, location_category_name, display_order) VALUES (?, ?, ?);"
        var insertQuery: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertString, -1, &insertQuery, nil) ==  SQLITE_OK {

            sqlite3_bind_int(insertQuery, 1, Int32(locationCategoryID))
            sqlite3_bind_text(insertQuery, 2, (locationCategoryName as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertQuery, 3, Int32(displayOrder))

            if sqlite3_step(insertQuery) == SQLITE_DONE {
                print("data inserted")
            }
            
            print("INSERT statement completed")
            
        } else {
            print("INSERT statment could not be prepared")
        }
        
    }
    
    func insertRowLocation(locationCategoryID: Int, locationName: String, displayOrder: Int) {
     
        let insertString = "INSERT INTO location (location_id, location_category_id, location_name, display_order) VALUES (?, ?, ?, ?);"
        var insertQuery: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertString, -1, &insertQuery, nil) ==  SQLITE_OK {

            if self.readTableLocation().isEmpty {
                sqlite3_bind_int(insertQuery, 1, 1)
            }
            
            sqlite3_bind_int(insertQuery, 2, Int32(locationCategoryID))
            sqlite3_bind_text(insertQuery, 3, (locationName as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertQuery, 4, Int32(displayOrder))

            if sqlite3_step(insertQuery) == SQLITE_DONE {
                print("data inserted")
            }
            
            print("INSERT statement completed")
            
        } else {
            print("INSERT statment could not be prepared")
        }
        
    }
    
    func insertRowFood(locationID: Int, foodName: String, expirationDate: String, tags: String, quantity: Int) {
       
        let insertString = "INSERT INTO food (food_id, location_id, food_name, expiration_date, tags, quantity) VALUES (?, ?, ?, ?, ?, ?);"
        var insertQuery: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertString, -1, &insertQuery, nil) ==  SQLITE_OK {

            if self.readTableFood().isEmpty {
                sqlite3_bind_int(insertQuery, 1, 1)
            }
            
            sqlite3_bind_int(insertQuery, 2, Int32(locationID))
            sqlite3_bind_text(insertQuery, 3, (foodName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertQuery, 4, (expirationDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertQuery, 5, (tags as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertQuery, 6, Int32(quantity))
            
            if sqlite3_step(insertQuery) == SQLITE_DONE {
                print("data inserted")
            }
            
            print("INSERT statement completed")
            
        } else {
            print("INSERT statment could not be prepared")
        }
        
    }
    
    func fillTableLocationCategory() {
        self.insertRowLocationCategory(locationCategoryID: 1, locationCategoryName: "Fridge", displayOrder: 1)
        self.insertRowLocationCategory(locationCategoryID: 2, locationCategoryName: "Freezer", displayOrder: 2)
        self.insertRowLocationCategory(locationCategoryID: 3, locationCategoryName: "Pantry", displayOrder: 3)
        self.insertRowLocationCategory(locationCategoryID: 4, locationCategoryName: "Other", displayOrder: 4)
    }
    
    func fillTableLocation() {
        self.insertRowLocation(locationCategoryID: 1, locationName: "Main Fridge", displayOrder: 1)
        self.insertRowLocation(locationCategoryID: 2, locationName: "Main Freezer", displayOrder: 2)
        self.insertRowLocation(locationCategoryID: 3, locationName: "Main Pantry", displayOrder: 3)
    }
    
    func readTableLocationCategory() -> [LocationCategory] {
        
        let selectLocationCategoryString = "SELECT * FROM location_category;"
        var selectLocationCategoryQuery: OpaquePointer? = nil
        var locationCategoryList: [LocationCategory] = []
        
        if sqlite3_prepare(self.db, selectLocationCategoryString, -1, &selectLocationCategoryQuery, nil) == SQLITE_OK {
            
            while sqlite3_step(selectLocationCategoryQuery) == SQLITE_ROW {
                
                let locationCategoryID = Int(sqlite3_column_int(selectLocationCategoryQuery, 0))
                let locationCategoryName = String(describing: String(cString: sqlite3_column_text(selectLocationCategoryQuery, 1)))
                let displayOrder = Int(sqlite3_column_int(selectLocationCategoryQuery, 2))
                locationCategoryList.append(LocationCategory(locationCategoryID: locationCategoryID, locationCategoryName: locationCategoryName, displayOrder: displayOrder))
                
            }
            
        } else {
            print("SELECT statement could not be prepared5")
        }
        
        return locationCategoryList
        
    }
    
    func readTableLocation() -> [Location] {
                
        let selectLocationString = "SELECT * FROM location ORDER BY display_order;"
        var selectLocationQuery: OpaquePointer? = nil
        var locationList: [Location] = []
            
        if sqlite3_prepare(db, selectLocationString, -1, &selectLocationQuery, nil) == SQLITE_OK {
                    
            while sqlite3_step(selectLocationQuery) == SQLITE_ROW {
                let locationID = Int(sqlite3_column_int(selectLocationQuery, 0))
                let locationCategoryID = Int(sqlite3_column_int(selectLocationQuery, 1))
                let locationName = String(describing: String(cString: sqlite3_column_text(selectLocationQuery, 2)))
                let displayOrder = Int(sqlite3_column_int(selectLocationQuery, 1))
                locationList.append(Location(locationID: locationID, locationCategoryID: locationCategoryID, locationName: locationName, displayOrder: displayOrder))
                
            }
                    
        } else {
            print("SELECT statement could not be prepared")
        }
             
        return locationList
        
    }
    
    func readTableFood() -> [Food] {
                
        let selectFoodString = "SELECT * FROM food;"
        var selectFoodQuery: OpaquePointer? = nil
        var foodList: [Food] = []
            
        if sqlite3_prepare(db, selectFoodString, -1, &selectFoodQuery, nil) == SQLITE_OK {
                
            while sqlite3_step(selectFoodQuery) == SQLITE_ROW {
                let foodID = Int(sqlite3_column_int(selectFoodQuery, 0))
                let storageID = Int(sqlite3_column_int(selectFoodQuery, 1))
                let foodName = String(describing: String(cString: sqlite3_column_text(selectFoodQuery, 2)))
                let expirationDate = String(describing: String(cString: sqlite3_column_text(selectFoodQuery, 3)))
                let tags = String(describing: String(cString: sqlite3_column_text(selectFoodQuery, 4)))
                let quantity = Int(sqlite3_column_int(selectFoodQuery, 5))

                foodList.append(Food(foodID: foodID, storageID: storageID, foodName: foodName, expirationDate: expirationDate, tags: tags, quantity: quantity))
            }
                    
        } else {
            print("SELECT statement could not be prepared")
        }
            
        return foodList
        
    }
    
    func readTableFood(locationID: Int) -> [Food]{

        //let selectFoodString = "SELECT * FROM food WHERE location_id = \(locationID);"
        let selectFoodString = "SELECT * FROM food WHERE location_id = \(locationID) ORDER BY expiration_date;"
        var selectFoodQuery: OpaquePointer? = nil
        var foodList: [Food] = []
                
        if sqlite3_prepare(db, selectFoodString, -1, &selectFoodQuery, nil) == SQLITE_OK {
                    
        //            print(sqlite3_step(selectStorageLocationQuery))
        //            print(SQLITE_ROW)
        //            print(sqlite3_step(selectStorageLocationQuery) == SQLITE_ROW)
        //
        //            print(sqlite3_step(selectStorageLocationQuery) == SQLITE_ROW)

                    
        //            print(sqlite3_step(selectStorageLocationQuery))
        //            print(SQLITE_ROW)
//            print(sqlite3_step(selectFoodQuery))
//            print(SQLITE_ROW)
            
            //print(sqlite3_step(selectFoodQuery) == SQLITE_ROW)
            while sqlite3_step(selectFoodQuery) == SQLITE_ROW {
                let foodID = Int(sqlite3_column_int(selectFoodQuery, 0))
                let storageID = Int(sqlite3_column_int(selectFoodQuery, 1))
                let foodName = String(describing: String(cString: sqlite3_column_text(selectFoodQuery, 2)))
                let expirationDate = String(describing: String(cString: sqlite3_column_text(selectFoodQuery, 3)))
                let tags = String(describing: String(cString: sqlite3_column_text(selectFoodQuery, 4)))
                let quantity = Int(sqlite3_column_int(selectFoodQuery, 5))

                foodList.append(Food(foodID: foodID, storageID: storageID, foodName: foodName, expirationDate: expirationDate, tags: tags, quantity: quantity))
            }
                    
        } else {
            print("SELECT statement could not be prepared")
        }
                
                //sqlite3_finalize(selectStorageLocationQuery)
                
        return foodList
                
    }
        
    
    func deleteLocation(locationID: Int) {
        
//        let deleteStorageLocationString = "DELETE FROM food WHERE location_id = \(locationID); DELETE FROM location WHERE location_id = \(locationID);"
        
        let deleteFoodString = "DELETE FROM food WHERE location_id = \(locationID);"
        var deleteFoodQuery: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteFoodString, -1, &deleteFoodQuery, nil) == SQLITE_OK {
            
            if sqlite3_step(deleteFoodQuery) == SQLITE_DONE {
                print("Row successfully deleted")
            } else {
                print("Could not delete row")
            }
            
        } else {
            print("Delete statement could not be prepared")
        }
        
        let deleteLocationString = "DELETE FROM location WHERE location_id = \(locationID);"
        var deleteLocationQuery: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteLocationString, -1, &deleteLocationQuery, nil) == SQLITE_OK {
            
            if sqlite3_step(deleteLocationQuery) == SQLITE_DONE {
                print("Row successfully deleted")
            } else {
                print("Could not delete row")
            }
            
        } else {
            print("Delete statement could not be prepared")
        }
    }
    
    func deleteRowFood(foodID: Int) {
        
        let deleteLoggedFoodString = "DELETE FROM food WHERE food_id = \(foodID);"
        var deleteLoggedFoodQuery: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteLoggedFoodString, -1, &deleteLoggedFoodQuery, nil) == SQLITE_OK {
            
            if sqlite3_step(deleteLoggedFoodQuery) == SQLITE_DONE {
                print("Row successfully deleted")
            } else {
                print("Could not delete row")
            }
            
        } else {
            print("Delete statement could not be prepared")
        }
    }
    
    func searchForFood(foodNameSearchString: String, locationID: Int) -> [Food]{
            
        let selectSearchString = "SELECT * FROM food WHERE (food_name LIKE '%\(foodNameSearchString)%' OR tags LIKE '%\(foodNameSearchString)%') AND location_id = \(locationID);"
        var selectSearchQuery: OpaquePointer? = nil
        var updatedSearchResultsList: [Food] = []
            
        if sqlite3_prepare(db, selectSearchString, -1, &selectSearchQuery, nil) == SQLITE_OK {
                
//            print(sqlite3_step(selectStorageLocationQuery))
//            print(SQLITE_ROW)
//            print(sqlite3_step(selectStorageLocationQuery) == SQLITE_ROW)
//
//            print(sqlite3_step(selectStorageLocationQuery) == SQLITE_ROW)

                
//            print(sqlite3_step(selectStorageLocationQuery))
//            print(SQLITE_ROW)
            while sqlite3_step(selectSearchQuery) == SQLITE_ROW {
                let foodID = Int(sqlite3_column_int(selectSearchQuery, 0))
                let storageID = Int(sqlite3_column_int(selectSearchQuery, 1))
                let foodName = String(describing: String(cString: sqlite3_column_text(selectSearchQuery, 2)))
                let expirationDate = String(describing: String(cString: sqlite3_column_text(selectSearchQuery, 3)))
                let tags = String(describing: String(cString: sqlite3_column_text(selectSearchQuery, 4)))
                let quantity = Int(sqlite3_column_int(selectSearchQuery, 5))

                updatedSearchResultsList.append(Food(foodID: foodID, storageID: storageID, foodName: foodName, expirationDate: expirationDate, tags: tags, quantity: quantity))
            }
                
        }
            
        return updatedSearchResultsList
            
    }
    
    func searchForFoodLocation(foodNameSearchString: String) -> [Location] {
            
        let selectSearchResultsString = "SELECT * FROM food WHERE food_name LIKE '%\(foodNameSearchString)%' OR tags LIKE '%\(foodNameSearchString)%';"
        var selectSearchResultsQuery: OpaquePointer? = nil
        var locationIDList: [Int] = []
        var updatedSearchResultsList: [Location] = []

        if sqlite3_prepare(db, selectSearchResultsString, -1, &selectSearchResultsQuery, nil) == SQLITE_OK {
                
//            print(sqlite3_step(selectStorageLocationQuery))
//            print(SQLITE_ROW)
//            print(sqlite3_step(selectStorageLocationQuery) == SQLITE_ROW)
//
//            print(sqlite3_step(selectStorageLocationQuery) == SQLITE_ROW)

                
//            print(sqlite3_step(selectStorageLocationQuery))
//            print(SQLITE_ROW)
            while sqlite3_step(selectSearchResultsQuery) == SQLITE_ROW {
                let locationID = Int(sqlite3_column_int(selectSearchResultsQuery, 1))
                
                if (locationIDList.count == 0) {
                    locationIDList.append(locationID)
                }
                    
                if !locationIDList.contains(locationID) {
                    locationIDList.append(locationID)
                }
                
            }
            
        }
            
        var counter = 0
        var locationIDString = ""
            
        while counter < locationIDList.count {
            
            if (counter != locationIDList.count - 1) {
                locationIDString += "location_id = \(locationIDList[counter]) OR "
            } else {
                locationIDString += "location_id = \(locationIDList[counter])"
            }
            
            counter += 1
                
        }
            
        if locationIDString != "" {
            let selectLocationSearchString = "SELECT * FROM location WHERE \(locationIDString) ORDER BY display_order;"
            var selectLocationSearchQuery: OpaquePointer? = nil
                        
            if sqlite3_prepare(db, selectLocationSearchString, -1, &selectLocationSearchQuery, nil) == SQLITE_OK {
                
                while sqlite3_step(selectLocationSearchQuery) == SQLITE_ROW {
                    let locationID = Int(sqlite3_column_int(selectLocationSearchQuery, 0))
                    let locationCategoryID = Int(sqlite3_column_int(selectLocationSearchQuery, 1))
                    let locationName = String(describing: String(cString: sqlite3_column_text(selectLocationSearchQuery, 2)))
                    let displayOrder = Int(sqlite3_column_int(selectLocationSearchQuery, 1))
                    updatedSearchResultsList.append(Location(locationID: locationID, locationCategoryID: locationCategoryID, locationName: locationName, displayOrder: displayOrder))
                            
                }
                        
            }
            
        }
        
        
        return updatedSearchResultsList
            
    }
    
    func daysTillExpiration(expirationDate: String) -> Int {
        
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "MM/dd/yyyy"
//        let showDate = inputFormatter.date(from: expirationDate)
//        inputFormatter.dateFormat = "yyyy-MM-dd"
//        var resultString = ""
//        if showDate != nil {
//            resultString = inputFormatter.string(from: showDate!)
//            print(resultString)
//        } else {
//            print("Entered Date is Invalid")
//        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: expirationDate)
        
        let secondsTillExpiration = date?.timeIntervalSinceNow
        
        //print(secondsTillExpiration/86400)
        
        let daysTillExpiration = ceil(secondsTillExpiration!/86400)
        
        return Int(daysTillExpiration)
        
//        // Specify date components
//        var dateComponents = DateComponents()
//        dateComponents.year = 1980
//        dateComponents.month = 7
//        dateComponents.day = 11
//        dateComponents.timeZone = TimeZone(abbreviation: "JST") // Japan Standard Time
//        dateComponents.hour = 8
//        dateComponents.minute = 34
//
//        // Create date from components
//        let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
//        let someDateTime = userCalendar.date(from: dateComponents)
        
//        let daysTillExpirationString = "SELECT julianday('\(expirationDate)') - julianday('now');"
//        var daysTillExpirationQuery: OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(db, daysTillExpirationString, -1, &daysTillExpirationQuery, nil) == SQLITE_OK {
//
//            if sqlite3_step(daysTillExpirationQuery) == SQLITE_ROW {
//                print(sqlite3_column_int(daysTillExpirationQuery, 0))
//            } else {
//                print("Storage Location Table Could Not Be Created")
//            }
//
//        } else {
//            print("CREATE TABLE statement could not be prepared")
//        }
//
//        var returnValue = Int(sqlite3_column_int(daysTillExpirationQuery, 0))
//        print(returnValue)
//
//        returnValue += 1
//        return returnValue
        
    }
    
    func updateFood(foodID: Int, locationID: Int, foodName: String, expirationDate: String, tags: String, quantity: Int) {
        
        let updateString = "UPDATE food SET location_id = '\(locationID)', food_name = '\(foodName)', expiration_date = '\(expirationDate)', tags = '\(tags)', quantity = '\(quantity)' WHERE food_id = \(foodID);"
        var updateQuery: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateString, -1, &updateQuery, nil) == SQLITE_OK {
            
            if sqlite3_step(updateQuery) == SQLITE_DONE {
                print("Row successfully updated")
            } else {
                print("Could not update row")
            }
            
        } else {
            print("Update statement could not be prepared")
        }
        
    }
    
    func deleteTable(tableName: String) {

        let deleteString = "DROP TABLE \(tableName);"
        var deleteQuery: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, deleteString, -1, &deleteQuery, nil) == SQLITE_OK {

            if sqlite3_step(deleteQuery) == SQLITE_DONE {
                print("Row successfully deleted")
            } else {
                print("Could not delete row")
            }

        } else {
            print("Delete statement could not be prepared")
        }
    }

}

    


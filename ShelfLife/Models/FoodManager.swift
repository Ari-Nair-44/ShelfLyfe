//
//  FoodManager.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/6/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import Foundation

class FoodManager {
        
    var delegate: FoodManagerDelegate?
        
    //    let baseURL = "https://api.edamam.com/api/food-database/v2/parser"
    //    let app_id = "36a59b09"
    //    let app_key = "b78c8222016fcf91c20c6b328c9389f9"
        
    let baseURL = "https://world.openfoodfacts.org/api/v0/product/"
    
    func getFoodName(for upc: String) {
        let urlString = "\(self.baseURL)\(upc)"
    //        let urlString = "\(baseURL)?upc=\(upc)&app_id=\(app_id)&app_key=\(app_key)"
        print (urlString)
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                    
                if let safeData = data {
                    if let foodName = self.parseJSON(safeData) {
                        self.delegate?.didUpdateFood(food: foodName)
                    }
                }
                
            }
                
            task.resume()
                
        }
        
    }
        
    func parseJSON(_ data: Data) -> String? {
            
        let decoder = JSONDecoder()
            
        do {
            let decodedData = try decoder.decode(FoodData.self, from: data)
    //           let foodName = decodedData.hints[0].food.label
            let foodName = decodedData.product.product_name
            return foodName
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
            
    }

}

    


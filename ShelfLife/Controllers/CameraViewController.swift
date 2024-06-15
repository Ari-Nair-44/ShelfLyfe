//
//  CameraViewController.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/6/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var camera: Camera?
    var foodManager = FoodManager()
    
    var cameraHelper: CameraHelper?
    var db: LocalDatabase?
    var locationList: [Location]?
    var locationID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
            self.camera?.metaDataOutput?.rectOfInterest = (self.camera?.previewLayer?.metadataOutputRectConverted(fromLayerRect: (self.camera?.scanRect)!))!
        }
        
    override func viewWillAppear(_ animated: Bool) {
        self.camera = Camera(withViewController: self, view: self.view, codeOutputHandler: handleCode)
        self.foodManager.delegate = self
        self.cameraHelper = CameraHelper(viewController: self, storyboard: self.storyboard!, db: self.db!, locationList: self.locationList!, locationID: self.locationID)
    }
        
    func handleCode(code: String) {
        print(code)
        self.foodManager.getFoodName(for: code)
    }

}

extension CameraViewController: AVCaptureMetadataOutputObjectsDelegate {

    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.camera?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }

}

extension CameraViewController: FoodManagerDelegate {

    func didUpdateFood(food: String) {
        print(food)
        
        self.cameraHelper?.scanSuccessful(foodName: food)
            
    //        let alert = UIAlertController(title: "Barcode Scanned!", message: food, preferredStyle: UIAlertController.Style.alert)
    //
    //        DispatchQueue.main.async {
    //            self.present(alert, animated: true)
    //        }
            
    }
        
    func didFailWithError(error: Error) {
        print(error)
        
        let alert = UIAlertController(title: "Could Not Identify Product", message: "Would You Like to Add the Item Manually?", preferredStyle: UIAlertController.Style.alert)
        let addManuallyAction = UIAlertAction(title: "Add Manually", style: .default) { (action) in
            self.cameraHelper?.addProductManually()
        }
            
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .destructive) { (action) in
            self.viewWillAppear(true)
        }
            
        alert.addAction(tryAgainAction)
        alert.addAction(addManuallyAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

}

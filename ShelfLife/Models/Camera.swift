//
//  Camera.swift
//  ShelfLife
//
//  Created by Dev User1 on 7/6/21.
//  Copyright © 2021 ari nair. All rights reserved.
//

import AVFoundation
import UIKit

class Camera: NSObject {
    
    private var viewController: UIViewController
    private var captureSession: AVCaptureSession?
    private var codeOutputHandler: (_ code: String) -> Void
    private var view : UIView
    let layer = CAShapeLayer()
    var scanRect: CGRect?
    var metaDataOutput: AVCaptureMetadataOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var c = Constants()
    
    init(withViewController viewController: UIViewController, view: UIView, codeOutputHandler: @escaping (String) -> Void) {
        
        self.viewController = viewController
        self.codeOutputHandler = codeOutputHandler
        self.view = view
        super.init()
        
        let sizeX = 300
        let sizeY = 150

        scanRect = CGRect(x: Int(view.center.x - CGFloat((sizeX / 2))), y: Int(view.center.y - CGFloat((sizeY) / 2)), width: sizeX, height: sizeY)
        layer.path = UIBezierPath(rect: scanRect!).cgPath

        //layer.path = UIBezierPath(rect: CGRect(x: 64, y: 64, width: 160, height: 160)).cgPath
        //layer.path = UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 160, height: 160), cornerRadius: 0).cgPath
        layer.borderWidth = 20
        layer.strokeColor = self.c.foodGoodColor.cgColor
        layer.fillColor = .none
        
        if let captureSession = self.createCaptureSession() {
            print("capture session created")
            self.captureSession = captureSession
            self.requestCaptureSessionStartRunning()
            previewLayer = self.createPreviewLayer(withCaptureSession: captureSession, view: view)
//            view.frame = previewLayer.frame
            //self.metaDataOutput?.rectOfInterest = previewLayer?.layerRectConverted(fromMetadataOutputRect: scanRect!)
            view.layer.addSublayer(previewLayer!)
        }
        
    }
    
    private func createCaptureSession() -> AVCaptureSession? {
        
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            return nil
        }
        
        do {
            
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            metaDataOutput = AVCaptureMetadataOutput()
            
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            } else {
                print("input error")
            }
            
            if captureSession.canAddOutput(metaDataOutput!) {
                captureSession.addOutput(metaDataOutput!)
                if let viewController = self.viewController as? AVCaptureMetadataOutputObjectsDelegate {
                    metaDataOutput?.setMetadataObjectsDelegate(viewController, queue: DispatchQueue.main)
                    metaDataOutput?.metadataObjectTypes = self.metaObjectTypes()
                    //metaDataOutput.rectOfInterest = AVCaptureVideoPreviewLayer().metadataOutputRectConverted(fromLayerRect: self.layer.path as! CGRect)
                }
            } else {
                print("output error")
            }
            
        } catch {
            print("catch")
            return nil
        }

        return captureSession
    
    }
    
    private func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
        return [.ean13, .ean8, .upce, .code128, .code39, .code39Mod43, .interleaved2of5, .itf14]
    }
    
    private func createPreviewLayer(withCaptureSession captureSession: AVCaptureSession, view: UIView) -> AVCaptureVideoPreviewLayer {
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        
        previewLayer.addSublayer(layer)
        return previewLayer
        
    }
    
    func requestCaptureSessionStartRunning() {
    
        guard let captureSession = self.captureSession else {
            return
        }
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }

    }
    
    func requestCaptureSessionStopRunning() {
        
        guard let captureSession = self.captureSession else {
            return
        }
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        
    }
    
    func scannerDelegate(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        let upcBarcodeValue: String
        
        self.requestCaptureSessionStopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            
            guard let eanBarcodeValue = readableObject.stringValue else {
                return
            }
            
            if eanBarcodeValue.hasPrefix("0") && eanBarcodeValue.count > 12{
                upcBarcodeValue = "\(eanBarcodeValue.dropFirst())"
            } else {
                upcBarcodeValue = "\(eanBarcodeValue)"
            }
            
            self.codeOutputHandler(upcBarcodeValue)
            
        }
        
    }
    
}

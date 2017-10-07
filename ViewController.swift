//
//  ViewController.swift
//  EZWifi
//
//  Created by nathan on 10/6/17.
//  Copyright © 2017 Nathan Pham. All rights reserved.
//

import UIKit
import AVFoundation
import NetworkExtension

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var scanImageView: UIImageView!
    
    var scanVideo = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let WiFiConfig = NEHotspotConfiguration(ssid: "BSCSlow", passphrase: "coopdemocracy", isWEP: false)
//
//        WiFiConfig.joinOnce = false
//        NEHotspotConfigurationManager.shared.apply(WiFiConfig) { error in
//
//            print ("HI")
//            // Handle error or success
//            print(error?.localizedDescription as Any)
//        }
        
        var configuration = NEHotspotConfiguration.init(ssid: "BSCSlow", passphrase: "coopdemocracy", isWEP: false)
        configuration.joinOnce = true
        
        NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
            if error != nil {
                //an error accured
                print(error?.localizedDescription)
            }
            else {
                //success
            }
        }
        
//        let session = AVCaptureSession()
//
//        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
//
//        do {
//            let input = try AVCaptureDeviceInput(device: captureDevice!)
//            session.addInput(input)
//        }
//        catch {
//            print("ERROR!")
//        }
//
//        let output = AVCaptureMetadataOutput()
//        session.addOutput(output)
//        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//
//        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//
//        scanVideo = AVCaptureVideoPreviewLayer(session: session)
//
//        // Fill the entire screen
//        scanVideo.frame = view.layer.bounds
//        view.layer.addSublayer(scanVideo)
//
//        self.view.bringSubview(toFront: scanImageView)
        
        // Start the session
//        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr{
                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Retake", comment: "Default action"), style: .`default`, handler: nil))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Copy", comment: "Default action"), style: .`default`, handler: {(nil) in UIPasteboard.general.string = object.stringValue}))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }

   


}


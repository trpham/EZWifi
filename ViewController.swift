//
//  ViewController.swift
//  EZWifi
//
//  Created by nathan on 10/6/17.
//  Copyright © 2017 Nathan Pham. All rights reserved.
//

/*
 * QRCodeReader.swift
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import AVFoundation
import UIKit
import NetworkExtension

class ViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    //  @IBOutlet weak var previewView: QRCodeReaderView!
    lazy var reader: QRCodeReader = QRCodeReader()
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // MARK: - Actions
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
            
//            present(alert, animated: true, completion: nil)
            
            // Start Scanning agian
//            reader.startScanning()
            
            return false
        }
    }
    
    
    
    @IBAction func scanInModalAction(_ sender: Any) {
        print("hi")
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    //  @IBAction func scanInPreviewAction(_ sender: Any) {
    //    guard checkScanPermissions(), !reader.isRunning else { return }
    //
    //    previewView.setupComponents(showCancelButton: false, showSwitchCameraButton: false, showTorchButton: false, showOverlayView: true, reader: reader)
    //
    //    reader.startScanning()
    //    reader.didFindCode = { result in
    //      let alert = UIAlertController(
    //        title: "QRCodeReader",
    //        message: String (format:"%@ (of type %@)", result.value, result.metadataType),
    //        preferredStyle: .alert
    //      )
    //      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    //    }
    //  }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
                let WiFiConfig = NEHotspotConfiguration(ssid: "BSCSlow", passphrase: "coopdemocracy", isWEP: false)
        
                WiFiConfig.joinOnce = false
                NEHotspotConfigurationManager.shared.apply(WiFiConfig) { error in
        
                    print ("HI")
                    // Handle error or success
                    print(error?.localizedDescription as Any)
                    reader.startScanning()
                }
//        reader.startScanning()
        
//        print("hi")
//        guard checkScanPermissions() else { return }
//        
//        readerVC.modalPresentationStyle = .formSheet
//        readerVC.delegate               = self
//        
//        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
//            if let result = result {
//                print("Completion with result: \(result.value) of type \(result.metadataType)")
//            }
//        }
        
//        present(readerVC, animated: true, completion: nil)
//
//        present(readerVC, animated: true, completion: nil)
        
//        dismiss(animated: true) { [weak self] in
//            let alert = UIAlertController(
//                title: "QRCodeReader",
//                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//            self?.present(alert, animated: true, completion: nil)
//        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
}

//        let WiFiConfig = NEHotspotConfiguration(ssid: "BSCSlow", passphrase: "coopdemocracy", isWEP: false)
//
//        WiFiConfig.joinOnce = false
//        NEHotspotConfigurationManager.shared.apply(WiFiConfig) { error in
//
//            print ("HI")
//            // Handle error or success
//            print(error?.localizedDescription as Any)
//        }
        
//        var configuration = NEHotspotConfiguration.init(ssid: "BSCSlow", passphrase: "coopdemocracy", isWEP: false)
//        configuration.joinOnce = false
//
//        NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
//            if error != nil {
//                //an error accured
//                print(error?.localizedDescription)
//            }
//            else {
//                //success
//            }
//        }
        
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
//    }
    
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        if metadataObjects.count != 0 {
//            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
//                if object.type == AVMetadataObject.ObjectType.qr{
//                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: NSLocalizedString("Retake", comment: "Default action"), style: .`default`, handler: nil))
//                    alert.addAction(UIAlertAction(title: NSLocalizedString("Copy", comment: "Default action"), style: .`default`, handler: {(nil) in UIPasteboard.general.string = object.stringValue}))
//
//                    present(alert, animated: true, completion: nil)
//                }
//            }
//        }
//
//    }

   


//}


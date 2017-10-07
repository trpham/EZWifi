//
//  QRGeneratorViewController.swift
//  EZWifi
//
//  Created by nathan on 10/7/17.
//  Copyright © 2017 Nathan Pham. All rights reserved.
//

import UIKit
//import QRCode

class QRGeneratorViewController: UIViewController {

    @IBOutlet weak var QRCodeImageView: UIImageView!
    
    @IBOutlet weak var SSID: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let codeGenerator = FCBBarCodeGenerator()
    
    @IBAction func generateQRCode(_ sender: Any) {
        
//        print ("hi")
        
        let wifiSecretKey = MD5(SSID.text! + "" + password.text!)
        
        print ("111 wifisecretKey --> " + wifiSecretKey)
        
        let size = CGSize(width: QRCodeImageView.frame.width , height: QRCodeImageView.frame.height)
        
        if let image = codeGenerator.barcode(code: wifiSecretKey, type: .qrcode, size: size) {
            QRCodeImageView.image = image
        } else {
            QRCodeImageView.image = nil
        }
        
        password.resignFirstResponder()
        SSID.resignFirstResponder()
        
//        QRCodeImageView.image = {
//            var qrCode = QRCode(wifiSecretKey)
//            qrCode?.size = self.QRCodeImageView.bounds.size
//            qrCode?.errorCorrection = .High
//            return qrCode?.image
//        }()
        
//        submitWifi(wifiSecretKey, SSID.text, password.text)
    }
    
//    func submitWifi(wifiSecretKey) {
//
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension QRGeneratorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case SSID:
            SSID.becomeFirstResponder()
        case password:
            password.becomeFirstResponder()
        default:
            password.resignFirstResponder()
        }
        return true
    }
}

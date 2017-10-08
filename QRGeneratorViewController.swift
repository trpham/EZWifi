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
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
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
        
        submitWifi(wifiSecretKey: wifiSecretKey, ssid: SSID.text!, password: password.text!)
    }
    
    func submitWifi(wifiSecretKey: String, ssid: String, password: String) {
        let url = "http://ezwifi.azurewebsites.net/putWifiInfo/" + wifiSecretKey + "/" + ssid + "/" + password
        
        let params = [String:String]()
        
        HTTP.POST(url, parameters: params) { response in
            //do things...
//            print("111 data is: \(response.error)")
//            print("222 data is: \(response.description)")
//            print("333 data is: \(response.data)")
        }
//        let url = "http://ezwifi.azurewebsites.net/getWifiInfo/test1"
//        HTTP.GET(url) { response in
//            if let err = response.error {
//                print("error: \(err.localizedDescription)")
//                return //also notify app of failure as needed
//            }
//            print("opt finished: \(response.description)")
//            print("data is: \(response.data)")
//        }
    }
    
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

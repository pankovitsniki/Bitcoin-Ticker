//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var currencySelected = ""
    var finalURL = ""

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = baseURL + currencies[row]
        
        currencySelected = getSymbolForCurrencyCode(code: "\(currencies[row])")!
        
        getBitcoinData(url: finalURL)
        
    }
    
    func getSymbolForCurrencyCode(code: String) -> String?
    {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    
    
//    //MARK: - Networking

    func getBitcoinData(url: String) {

        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the bitcoin data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)

                    self.updateBitcoinData(json: bitcoinJSON)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }


    //MARK: - JSON Parsing

    func updateBitcoinData(json : JSON) {

        let currency = json["tokens"]["symbols"].stringValue
        
        currencyPicker.dataSource = currency as? UIPickerViewDataSource
        
        if let bitcoinResult = json["last"].double {
            var results = ("\(currencySelected)") + "\(bitcoinResult)"
//            bitcoinPriceLabel.text = ("\(currencySelected)" + String(bitcoinResult))
//            let formatter = NumberFormatter()
//            formatter.numberStyle = .currency
//            formatter.string(from: currencyPicker.dataSource as! NSNumber)
//            formatter.locale = Locale(identifier: "\(currencySelected)")
//            formatter.string(from: currencyPicker.dataSource as! NSNumber)
            
            bitcoinPriceLabel.text = results

            
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
    }
    
}


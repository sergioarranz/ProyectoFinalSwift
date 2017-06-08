//
//  ViewController.swift
//  Mobiles
//
//  Created by Sergio Arranz Sobrino on 7/6/17.
//  Copyright © 2017 Sergio Arranz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet var imgPhone: UIImageView!
    @IBOutlet var lblPhoneName: UILabel!
    @IBOutlet var lblRam: UILabel!
    @IBOutlet var lblBattery: UILabel!
    
    var box : [Phone] = []
    var myPhone : Phone! // Variable global de mi coche que conocerá toda la clase
    var phoneID : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myPhone = Phone(brand: "iPhone", model: "SE", ram: 3, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), battery: 1100.7, image: nil)
        box.append(myPhone)
        
        myPhone = Phone(brand: "Samsung", model: "Galaxy S8", ram: 4, color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), battery: 1357.5, image: #imageLiteral(resourceName: "samsung"))
        box.append(myPhone)
        
        myPhone = Phone(brand: "iPhone", model: "7", ram: 3, color: #colorLiteral(red: 0.7450980544, green: 0.1248145852, blue: 0.7231479443, alpha: 1), battery: 1230.7, image: #imageLiteral(resourceName: "iphone"))
        box.append(myPhone)
        
        myPhone = Phone(brand: "Sony", model: "Xperia E5", ram: 2, color: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), battery: 1230.7, image: #imageLiteral(resourceName: "sony"))
        box.append(myPhone)
        
        myPhone = Phone(brand: "Huawei", model: "P9 Lite", ram: 2, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), battery: 1500.0, image: #imageLiteral(resourceName: "huawei"))
        box.append(myPhone)
        
        updateView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView() {
        
        myPhone = box[phoneID]
        
        if myPhone.image != nil {
            self.imgPhone.image = myPhone.image
        } else {
            self.imgPhone.image = nil
        }
        
        self.lblPhoneName.text = "\(myPhone.brand!) \(myPhone.model!)"
        self.lblRam.text = "Memoria RAM : \(myPhone.ram!) GB"
        self.lblBattery.text = "Batería : \(myPhone.battery!) kWs"

        self.view.backgroundColor = myPhone.color
    }

    @IBAction func changePhone(_ sender: UIButton) {
        phoneID += 1
        if phoneID >= box.count {
            phoneID = 0
        }
        
        updateView()
    }

}


//
//  Phone.swift
//  Mobiles
//
//  Created by Sergio Arranz Sobrino on 7/6/17.
//  Copyright © 2017 Sergio Arranz. All rights reserved.
//

import Foundation
import UIKit

class Phone: NSObject {
    var brand : String!
    var model : String!
    var ram : Int!
    var color: UIColor!
    var battery: Double!
    var image : UIImage?
    
    /* Equivalente al toString de Java, var heredada de NSObject que actua como método y variable a la vez */
    override var description: String {
        return "Mi móvil es un \(brand!) \(model!) con \(ram!) GB de memoria RAM y con \(battery!) Kwh de batería"
    }
    
    /* Constructor por defecto */
    override init() {
        brand = "Desconocida"
        model = "Desconocido"
        ram = 0
        color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        battery = 0.0
    }
    
    /* Constructor con parámetros */
    init(brand: String, model: String, ram: Int, color: UIColor, battery: Double, image: UIImage?) {
        self.brand = brand
        self.model = model
        self.ram = ram
        self.color = color
        self.battery = battery
        
        if let image = image {
            self.image = image
        }
    }
    
    
}

//
//  Recipe.swift
//  Recetas Cocina
//
//  Created by Sergio Arranz on 8/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import Foundation
import UIKit

class Recipe: NSObject {
    
    var name : String!
    var image : UIImage!
    var time : Int!
    var ingredients : [String]!
    var steps : [String]!
   
    var rating: String = "rating"
    
    init(name: String, image: UIImage, time: Int, ingredients: [String], steps: [String]) {
        self.name = name
        self.image = image
        self.time = time
        self.ingredients = ingredients
        self.steps = steps
    }
    
    
}

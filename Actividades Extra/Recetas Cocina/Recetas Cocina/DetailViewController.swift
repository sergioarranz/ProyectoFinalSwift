//
//  DetailViewController.swift
//  Recetas Cocina
//
//  Created by Sergio Arranz on 12/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var recipeTime: UILabel!
    @IBOutlet var recipeIngredients: UILabel!
    
    var recipe : Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recipeName.text = self.recipe.name
        self.recipeImageView.image = self.recipe.image
        self.recipeTime.text = "\(self.recipe.time!) min."
        self.recipeIngredients.text = "Nº Ingredientes: \(self.recipe.ingredients.count)"
    }

}

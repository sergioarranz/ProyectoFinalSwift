//
//  ViewController.swift
//  Recetas Cocina
//
//  Created by Sergio Arranz on 8/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var recipes : [Recipe] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var recipe = Recipe(name: "Arroz con leche", image: #imageLiteral(resourceName: "arroz"), time: 20, ingredients: ["Patatas", "Huevos", "Cebollas"], steps: ["Pasos para cocinar la tortilla"])
        recipes.append(recipe)
        
        recipe = Recipe(name: "Tortitas con caramelo", image: #imageLiteral(resourceName: "tortita"), time: 10, ingredients: ["Tortitas", "Caramelo"], steps: ["Pasos para cocinar las tortitas"] )
        recipes.append(recipe)
        
        recipe = Recipe(name: "Estofado de ternera", image: #imageLiteral(resourceName: "estofado"), time: 15, ingredients: ["Estofado", "Ternera"], steps: ["Pasos para cocinar el estofado de ternera"])
        recipes.append(recipe)
        
        recipe = Recipe(name: "Muslo de pollo", image: #imageLiteral(resourceName: "muslo"), time: 5, ingredients: ["Pollo", "Perejil"], steps: ["Pasos para cocinar un muslo de pollo"])
        recipes.append(recipe)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        let cellID = "RecipeCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RecipeCell
        cell.thumbnailRecipe.image = recipe.image
        cell.lblName.text = recipe.name
        cell.lblTime.text = "\(recipe.time) min"
        cell.lblIngredients.text = "Ingredientes: \(recipe.ingredients.count)"
        
        return cell
    }
    
}


//
//  SingleViewController.swift
//  Recetas Cocina
//
//  Created by Sergio Arranz on 8/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var recipes : [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*self.tableView.dataSource = self
        self.tableView.delegate = self*/
        
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
    
}

extension SingleViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = recipes[indexPath.row]
        let cellID = "RecipeCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RecipeCell
        cell.thumbnailRecipe.image = recipe.image
        cell.lblName.text = recipe.name
        cell.lblTime.text = "\(recipe.time!) min"
        cell.lblIngredients.text = "Ingredientes: \(recipe.ingredients.count)"
        
        if recipe.isFavourite {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.recipes.remove(at: indexPath.row)
            
        }
        
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }

}

extension SingleViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recipe = self.recipes[indexPath.row]
        let alertController = UIAlertController(title: recipe.name, message: "Valora este plato", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        var favouriteActionTitle = "Favorito"
        var favouriteActionStyle = UIAlertActionStyle.default
        if recipe.isFavourite {
            favouriteActionTitle = "No favorito"
            favouriteActionStyle = UIAlertActionStyle.destructive

        }
        
        let favouriteAction = UIAlertAction(title: favouriteActionTitle, style: favouriteActionStyle) { (action) in
            let recipe = self.recipes[indexPath.row]
            recipe.isFavourite = !recipe.isFavourite
            self.tableView.reloadData()
        }
        alertController.addAction(favouriteAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}

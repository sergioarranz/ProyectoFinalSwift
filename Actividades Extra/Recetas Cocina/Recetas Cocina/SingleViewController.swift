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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        /*self.tableView.dataSource = self
        self.tableView.delegate = self
        (Lo mismo que linkarlos desde el main story board)*/
        
        var recipe = Recipe(name: "Arroz con leche", image: #imageLiteral(resourceName: "arroz"), time: 20, ingredients: ["Patatas", "Huevos", "Cebollas"], steps: ["Pasos para cocinar la tortilla"])
        recipes.append(recipe)
        
        recipe = Recipe(name: "Tortitas con caramelo", image: #imageLiteral(resourceName: "tortita"), time: 10, ingredients: ["Tortitas", "Caramelo"], steps: ["Pasos para cocinar las tortitas"] )
        recipes.append(recipe)
        
        recipe = Recipe(name: "Estofado de ternera", image: #imageLiteral(resourceName: "estofado"), time: 15, ingredients: ["Estofado", "Ternera"], steps: ["Pasos para cocinar el estofado de ternera"])
        recipes.append(recipe)
        
        recipe = Recipe(name: "Muslo de pollo", image: #imageLiteral(resourceName: "muslo"), time: 5, ingredients: ["Pollo", "Perejil"], steps: ["Pasos para cocinar un muslo de pollo"])
        recipes.append(recipe)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
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

        return cell
    }
    /* Borrar celdas por defecto antes de usar UIActivityViewControllers
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            self.recipes.remove(at: indexPath.row)
            
        }
        
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
     */
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction =  UITableViewRowAction(style: .default, title: "Compartir") { (action, indexPath) in
            
        // Compartir
            let shareDefaultText = "Estoy mirando la receta de \(self.recipes[indexPath.row].name!) en la App de recetas de cocina"
            
            let activityController = UIActivityViewController(activityItems: [shareDefaultText, self.recipes[indexPath.row].image!], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
        
        shareAction.backgroundColor = UIColor(colorLiteralRed: 30.0/255.0, green: 164.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        
        // Borrar
            let deleteAction =  UITableViewRowAction(style: .default, title: "Borrar") { (action, indexPath) in
            
            self.recipes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        deleteAction.backgroundColor = UIColor(colorLiteralRed: 202.0/255.0, green: 202.0/255.0, blue: 202.0/255.0, alpha: 1.0)
        
        return [shareAction, deleteAction]
    }

}

extension SingleViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*let recipe = self.recipes[indexPath.row]
        let alertController = UIAlertController(title: recipe.name, message: "Valora este plato", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Mostrar distintos tipos de mensajes y alertas en caso de plato favorito/no favorito
        var favouriteActionTitle = "Favorito"
        var favouriteActionStyle = UIAlertActionStyle.default
        if recipe.isFavourite {
            favouriteActionTitle = "No favorito"
            favouriteActionStyle = UIAlertActionStyle.destructive

        }
        // Creación de la alerta y display en pantalla de la misma
        let favouriteAction = UIAlertAction(title: favouriteActionTitle, style: favouriteActionStyle) { (action) in
            let recipe = self.recipes[indexPath.row]
            recipe.isFavourite = !recipe.isFavourite
            self.tableView.reloadData()
        }
        alertController.addAction(favouriteAction)
        
        self.present(alertController, animated: true, completion: nil)*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRecipeDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRecipe = self.recipes[indexPath.row]
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.recipe = selectedRecipe
            }
        }
    }
}

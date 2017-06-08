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
        
        var recipe = Recipe(name: "Arroz con leche", image: #imageLiteral(resourceName: "arroz"))
        recipes.append(recipe)
        
        recipe = Recipe(name: "Tortitas con caramelo", image: #imageLiteral(resourceName: "tortita") )
        recipes.append(recipe)
        
        recipe = Recipe(name: "Estofado de ternera", image: #imageLiteral(resourceName: "estofado"))
        recipes.append(recipe)
        
        recipe = Recipe(name: "Muslo de pollo", image: #imageLiteral(resourceName: "muslo"))
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
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = recipe.name
        cell.imageView?.image = recipe.image
        return cell
    }

}

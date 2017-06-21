//
//  VCInicio.swift
//  Genome Social Network
//
//  Created by Sergio Arranz on 01/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class VCInicio: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell: VCInicioCell = tableView.dequeueReusableCell(withIdentifier: "VCInicioCell", for: indexPath) as! VCInicioCell
        
        return cell
    }
    
    
}

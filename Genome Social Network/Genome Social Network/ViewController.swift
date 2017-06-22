//
//  ViewController.swift
//  Genome Social Network
//
//  Created by Sergio Arranz on 17/5/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Login automático
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, usuario) in
            
            if let UsuarioActual = usuario {
                
                print("Usuario logeado")
                
                // Enviar al usuario al Controlador de Inicio
                
                let StoryboardInicio: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                
                let VCMain: UIViewController = StoryboardInicio.instantiateViewController(withIdentifier: "VCTabBar")
                
                // Enviar al usuario a la vista principal
                self.present(VCMain, animated: true, completion: nil)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


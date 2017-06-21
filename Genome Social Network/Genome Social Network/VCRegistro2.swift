//
//  VCRegistro2.swift
//  Genome Social Network
//
//  Created by Sergio Arranz on 22/5/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class VCRegistro2: UIViewController {
    
    
    @IBOutlet var nombreCompleto: UITextField!
    @IBOutlet var nickname: UITextField!
    @IBOutlet var comenzar: UIBarButtonItem!
    @IBOutlet var MensajeError: UILabel!
    
    var user:AnyObject?
    
    var rootRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Guardar usuario
        self.user = FIRAuth.auth()?.currentUser
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pulsarComenzar(_ sender: Any) {
        
        let nick = self.rootRef.child("nicknames").child(self.nickname
            .text!).observeSingleEvent(of: .value, with: {(snapshot:FIRDataSnapshot) in
                
                if(!snapshot.exists())
                {
                    // Actualizar nick del usuario en el nodo interior de los nicknames dentro de perfiles
                    
                    self.rootRef.child("perfiles").child(self.user!.uid).child("nick").setValue(self.nickname.text!.lowercased())
                    
                    // Actualizar nombre completo del usuario en el nodo interior de los nicks dentro de perfiles
                    
                    self.rootRef.child("perfiles").child(self.user!.uid).child("nombre").setValue(self.nombreCompleto.text!)
                    
                    
                    //  Actualizar nick en el nodo nickname
                    
                    self.rootRef.child("nicknames").child(self.nickname.text!.lowercased()).setValue(self.user?.uid)
                    
                    //send the user to home screen
                    self.performSegue(withIdentifier: "transPrincipal", sender: nil)
                    
                } else {
                    self.MensajeError.text = "El nickname seleccionado ya está en uso!"
                }
            })
    }
    
    @IBAction func pulsarCancelar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

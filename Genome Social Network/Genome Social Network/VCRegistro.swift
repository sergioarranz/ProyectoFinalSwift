//
//  VCRegistro.swift
//  Genome Social Network
//
//  Created by Sergio Arranz on 20/5/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class VCRegistro: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    @IBOutlet weak var btnRegistro: UIBarButtonItem!
    @IBOutlet weak var mensajeError: UILabel!
    
    var databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnRegistro.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pulsarCancelar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pulsarRegistro(_ sender: Any) {
        // Botón de Registro deshabilitado en la acción para evitar que el usuario la mande más de una vez
        btnRegistro.isEnabled = false
        
        // Creación del usuario, inserción en los nodos de Firebase y login automático con transición a Registro2
        
        FIRAuth.auth()?.createUser(withEmail: txtEmail.text!, password: txtClave.text!, completion: { (user, error) in
            
            if(error != nil)
            {
                self.mensajeError.text = error?.localizedDescription
            } else {
                self.mensajeError.text = "Registro correcto"
                
                FIRAuth.auth()?.signIn(withEmail: self.txtEmail.text!, password: self.txtClave.text!, completion: { (usuario, error) in
                    if(error == nil){
                        self.databaseRef.child("perfiles").child(user!.uid).child("email").setValue(self.txtEmail.text!)
                        
                        self.performSegue(withIdentifier: "TransRegistro2", sender: nil)
                    }
                    
                })
            }
        })
    }
    
    // Evitar que el usuario pulse el botón antes de escribir en los campos
    @IBAction func cambiarTexto(_ sender: UITextField) {
        if((txtEmail.text?.characters.count)!>0 && (txtClave.text?.characters.count)!>0){
            btnRegistro.isEnabled = true
        } else {
            btnRegistro.isEnabled = false
        }
    }
}

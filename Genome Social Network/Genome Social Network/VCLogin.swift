//
//  VCLogin.swift
//  Genome Social Network
//
//  Created by Sergio Arranz on 24/5/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class VCLogin: UIViewController {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtClave: UITextField!
    @IBOutlet var MensajeError: UILabel!
    
    var rootRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        EsconderTecladoView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pulsarCancelar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func EsconderTecladoView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VCRegistro2.dismissKeyboard))
        
        //Descomentar, si el tap no debe interferir o cancelar otras acciones
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Las vistas y toda la jerarquía renuncia a responder, para esconder el teclado
        view.endEditing(true)
    }

    
    
    @IBAction func pulsarIniciarSesion(_ sender: Any) {
        
        // Login de usuario con Firebase y escuchar datos en el nodo nick de perfiles en Firebase devolviéndolos como SnapShot y comprobando si existen para transicionar a un VC u otro
        
        FIRAuth.auth()?.signIn(withEmail: self.txtEmail.text!, password: self.txtClave.text!, completion: { (user, error) in
            if(error == nil) {
                self.rootRef.child("perfiles").child((user?.uid)!).child("nick").observe(.value, with: { (snapshot:FIRDataSnapshot) in
                    
                    if(!snapshot.exists()){
                        // El usuario no tiene nick y por tanto transicionamos al VC de creación del mismo
                        self.performSegue(withIdentifier: "TransRegistro2", sender: nil)
                    } else {
                        // El usuario tiene nick y por tanto le llevamos a la página principal
                        self.performSegue(withIdentifier: "transPrincipal", sender: nil)
                    }
                })
            } else {
                self.MensajeError.text = error?.localizedDescription
            }
        })
    }
    
}

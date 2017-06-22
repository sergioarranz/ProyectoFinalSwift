//
//  VCNuevoPost.swift
//  Genome Social Network
//
//  Created by Sergio Arranz on 02/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class VCNuevoPost: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var TextViewPost: UITextView!
    
    @IBOutlet var BarraNuevoPost: UIToolbar!
    @IBOutlet var BarraFooterConstraint: NSLayoutConstraint!
    var BarraFooterConstraintValorInicial:CGFloat?
    
    // Referencia a la base de datos
    var databaseRef = FIRDatabase.database().reference()
    var UsuarioLogueado : AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.BarraNuevoPost.isHidden = true
        self.UsuarioLogueado = FIRAuth.auth()?.currentUser
        
        // Modificaciones iniciales a la TextView de los Posts
        TextViewPost.textContainerInset = UIEdgeInsetsMake(30, 20, 20, 20)
        TextViewPost.text = "En que estás pensando?"
        TextViewPost.textColor = UIColor.lightGray
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        enableKeyboardHideOnTap()
        
        self.BarraFooterConstraintValorInicial = BarraFooterConstraint.constant
    }
    
    fileprivate func enableKeyboardHideOnTap(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(VCNuevoPost.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VCNuevoPost.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VCNuevoPost.hideKeyboard))
        
        self.view.addGestureRecognizer(tap)
        
    }
    
    func keyboardWillShow(_ notification: Notification)
    {
        let info = (notification as NSNotification).userInfo!
        
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let duration = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration, animations: {
            
            self.BarraFooterConstraint.constant = keyboardFrame.size.height
            
            self.BarraNuevoPost.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification: Notification)
    {
        let duration = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration, animations: {
            
            self.BarraFooterConstraint.constant = self.BarraFooterConstraintValorInicial!
            
            self.BarraNuevoPost.isHidden = true
            self.view.layoutIfNeeded()
        })
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pulsarCancelar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Truco para hacer efecto de placeholder en la TextView cuando el texto se comience a editar
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(TextViewPost.textColor == UIColor.lightGray)
        {
            TextViewPost.text = ""
            TextViewPost.textColor = UIColor.black
        }
    }
    
    // Ocultar teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func pulsarPostear(_ sender: Any) {
        
        // Comprobamos si el usuario ha escrito algo antes de enviarlo
        if(TextViewPost.text.characters.count>0){
            
            // Obtenemos una llave de la base de datos y la almacenamos en un nodo "posts"
            let key = self.databaseRef.child("posts").childByAutoId().key
            
            // Actualizar posts en la base de datos bajo el nodo "posts" con atributos texto y fecha
            let actualizaciones = ["/posts/\(self.UsuarioLogueado!.uid!)/\(key)/text":TextViewPost.text,
                                   "/posts/\(self.UsuarioLogueado!.uid!)/\(key)/fecha":"\(Date().timeIntervalSince1970)"] as [String : Any]
            
            // Método para actualizar el post pasándole actualizaciones
            self.databaseRef.updateChildValues(actualizaciones)
            
            // Retiramos el VC una vez que el usuario publica el post
            dismiss(animated: true, completion: nil)
        }
    }
}

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
import FirebaseStorage

class VCNuevoPost: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var TextViewPost: UITextView!
    
    @IBOutlet var BarraNuevoPost: UIToolbar!
    @IBOutlet var BarraFooterConstraint: NSLayoutConstraint!
    var BarraFooterConstraintValorInicial:CGFloat?
    
    // Referencia a la base de datos
    var databaseRef = FIRDatabase.database().reference()
    var UsuarioLogueado : AnyObject?
    
    var seleccionarImagen = UIImagePickerController()
    
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
        
        var imagesArray = [AnyObject]()
        
        // Extraer las imágenes del AttributedText
        self.TextViewPost.attributedText.enumerateAttribute(NSAttachmentAttributeName, in: NSMakeRange(0, self.TextViewPost.text.characters.count), options: []) { (value, range, true) in
            
            // Comprobamos valor de retorno y añadimos al array o devolvemos error
            if(value is NSTextAttachment)
            {
                let attachment = value as! NSTextAttachment
                var image : UIImage? = nil
                
                // Comprobar si es una imágen
                if(attachment.image !== nil)
                {
                    image = attachment.image!
                    imagesArray.append(image!)
                }
                else
                {
                    print("La imágen no ha sido encontrada")
                }
            }
        }
        
        let PostLength = TextViewPost.text.characters.count
        let numImages = imagesArray.count
        
        // Creamos una clave única auto generada de Firebase
        let key = self.databaseRef.child("posts").childByAutoId().key
        
        let storageRef = FIRStorage.storage().reference()
        let pictureStorageRef = storageRef.child("perfiles/\(self.UsuarioLogueado!.uid)/media/\(key)")
        
        
        
        // Usuario ha introducido imágen y texto
        if(PostLength>0 && numImages>0)
        {
            // Reducimos la resolución de la imágen seleccionada
            let lowResImageData = UIImageJPEGRepresentation(imagesArray[0] as! UIImage, 0.50)
            
            let uploadTask = pictureStorageRef.put(lowResImageData!,metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    let childUpdates = ["/posts/\(self.UsuarioLogueado!.uid!)/\(key)/text":self.TextViewPost.text,
                                        "/posts/\(self.UsuarioLogueado!.uid!)/\(key)/fecha":"\(Date().timeIntervalSince1970)",
                        "/posts/\(self.UsuarioLogueado!.uid!)/\(key)/imagen":downloadUrl!.absoluteString] as [String : Any]
                    
                    self.databaseRef.updateChildValues(childUpdates)
                }
                
            }
            
            dismiss(animated: true, completion: nil)
        }
            // Usuario ha introducido solo texto
        else if(PostLength>0)
        {
            let childUpdates = ["/posts/\(self.UsuarioLogueado!.uid!)/\(key)/text":TextViewPost.text,
                                "/posts/\(self.UsuarioLogueado!.uid!)/\(key)/fecha":"\(Date().timeIntervalSince1970)"] as [String : Any]
            
            self.databaseRef.updateChildValues(childUpdates)
            
            dismiss(animated: true, completion: nil)
            
        }
            // Usuario ha introducido solo la imágen
        else if(numImages>0)
        {
            let lowResImageData = UIImageJPEGRepresentation(imagesArray[0] as! UIImage, 0.50)
            
            let uploadTask = pictureStorageRef.put(lowResImageData!,metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    let childUpdates = [
                        "/posts/\(self.UsuarioLogueado!.uid)/\(key)/fecha":"\(Date().timeIntervalSince1970)",
                        "/posts/\(self.UsuarioLogueado!.uid)/\(key)/imagen":downloadUrl!.absoluteString]
                    
                    self.databaseRef.updateChildValues(childUpdates)
                }
                else
                {
                    print(error?.localizedDescription)
                }
                
            }
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBAction func seleccionarImagenHecha(_ sender: Any) {
        
        // Abrir la galería de fotos
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            self.seleccionarImagen.delegate = self
            self.seleccionarImagen.sourceType = .savedPhotosAlbum
            self.seleccionarImagen.allowsEditing = true
            self.present(self.seleccionarImagen, animated: true, completion: nil)
        }
        
    }
    
    //after user has picked an image from photo gallery, this function will be called
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        var attributedString = NSMutableAttributedString() // Permite cambiar atributos y añadir contenido a un String
        
        if(self.TextViewPost.text.characters.count>0)
        {
            attributedString = NSMutableAttributedString(string:self.TextViewPost.text)
        }
        else
        {
            attributedString = NSMutableAttributedString(string:"En qué estas pensando?\n")
        }
        
        // Variable que nos permitirá adjuntar la imágen al texto y meterla en el attributedString
        let textAttachment = NSTextAttachment()
        
        textAttachment.image = image
        
        // Recogemos el tamaño de la imágen original
        let oldWidth:CGFloat = textAttachment.image!.size.width
        
        // Aseguramos que sea escalado a un tamaño que concuerde con el TextView
        let scaleFactor:CGFloat = oldWidth/(TextViewPost.frame.size.width-50)
        
        // Establecemos la imágen del textAttachment creado anteriormente
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        
        // Añadimos nuestro attributedString que contiene la imágen al attributedString creado arriba del todo
        attributedString.append(attrStringWithImage)
        
        TextViewPost.attributedText = attributedString
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
}

//
//  VCPerfil.swift
//  Genome Social Network
//
//  Created by Sergio Arranz on 03/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class VCPerfil: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet var postsContainer: UIView!
    @IBOutlet var mediaContainer: UIView!
    @IBOutlet var likesContainer: UIView!
    @IBOutlet var fotoPerfil: UIImageView!
    @IBOutlet var nombreCompleto: UILabel!
    @IBOutlet var nickname: UILabel!
    @IBOutlet var SobreMi: UITextField!
    @IBOutlet var cargarImagen: UIActivityIndicatorView!
    
    var UsuarioLogeado:AnyObject?
    
    // Referencias a DB y almacenamiento de Firebase
    var databaseRef = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference()
    
    var seleccionarImagen = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UsuarioLogeado = FIRAuth.auth()?.currentUser
        
        // Escuchamos datos del nodo perfiles y asignamos el nombre y el nick a las outlets
        self.databaseRef.child("perfiles").child(self.UsuarioLogeado!.uid).observe(.value, with: { (snapshot) in
            
            let snapshot = snapshot.value as! [String: AnyObject]
            
            self.nombreCompleto.text = snapshot["nombre"] as? String
            self.nickname.text = snapshot["nick"] as? String
            
            // El usuario no tendrá descripción por defecto
            if(snapshot["sobremi"] !== nil) {
                self.SobreMi.text = snapshot["sobremi"] as? String
            }
            // El usuario no tendrá foto de perfíl por defecto
            if(snapshot["foto_perfil"] !== nil) {
                let FotoPerfilRef = snapshot["foto_perfil"] as! String
                
                // Convierte a NSData la URL que es almacenada como String en la DB
                let data = try? Data(contentsOf: URL(string: FotoPerfilRef)!)
                
                self.definirFotoPerfil(self.fotoPerfil,imagen:UIImage(data:data!)!)
            }
            
            self.cargarImagen.stopAnimating()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pulsarDesconectar(_ sender: Any) {
        
        // Cerrar sesión actual del usuario en Firebase
        try! FIRAuth.auth()!.signOut()
        
        // Mandar al usuario a la pantalla principal
        let StoryboardInicio: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let VCMain: UIViewController = StoryboardInicio.instantiateViewController(withIdentifier: "VCMain")
        self.present(VCMain, animated: true, completion: nil)
    }
    
    // Mostrar contenedores en función del selectedSegmentIndex seleccionado
    @IBAction func mostrarComponentes(_ sender: AnyObject) {
        
        // Mostrar Posts
        if(sender.selectedSegmentIndex == 0) {
            UIView.animate(withDuration: 0.5, animations: {
                
                self.postsContainer.alpha = 1
                self.mediaContainer.alpha = 0
                self.likesContainer.alpha = 0
            })
        }
            // Mostrar Media
        else if(sender.selectedSegmentIndex == 1) {
            UIView.animate(withDuration: 0.5, animations: {
                
                self.mediaContainer.alpha = 1
                self.postsContainer.alpha = 0
                self.likesContainer.alpha = 0
                
            })
        }
            // Mostrar Likes
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.likesContainer.alpha = 1
                self.postsContainer.alpha = 0
                self.mediaContainer.alpha = 0
            })
        }
    }
    
    // Función interna que define los parámetros iniciales de la foto de perfíl
    internal func definirFotoPerfil(_ imageView:UIImageView,imagen:UIImage)
    {
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imagen
    }
    
    @IBAction func pulsarFotoPerfil(_ sender: UITapGestureRecognizer) {
        
        // Creación de Alerta de tipo ActionSheet
        
        let ActionSheet = UIAlertController(title:"Foto de perfíl",message:"Seleccionar fuente de imágen",preferredStyle: UIAlertControllerStyle.actionSheet)
        
        
        // Visualizar foto actual
        let verFoto = UIAlertAction(title: "Ver foto actual", style: UIAlertActionStyle.default) { (action) in
            
            // Recoger imágen, asignar atributos nuevos y función de retirar imágen al volver a presionar
            let imageView = sender.view as! UIImageView
            let nuevaImagen = UIImageView(image: imageView.image)
            
            nuevaImagen.frame = self.view.frame
            nuevaImagen.backgroundColor = UIColor.black
            nuevaImagen.contentMode = .scaleAspectFit
            nuevaImagen.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target:self,action:#selector(self.quitarImagenCompleta))
            
            nuevaImagen.addGestureRecognizer(tap)
            self.view.addSubview(nuevaImagen)
        }
        
        // Seleccionar foto de los albumes
        let seleccionarFoto = UIAlertAction(title: "Seleccionar de los albumes", style: UIAlertActionStyle.default) { (action) in
            
            // En caso de estar disponible la imágen delegar función y presentarla permitiendo interacción al usuario
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.savedPhotosAlbum)
            {
                self.seleccionarImagen.delegate = self
                self.seleccionarImagen.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.seleccionarImagen.allowsEditing = true
                self.present(self.seleccionarImagen, animated: true
                    , completion: nil)
            }
        }
        // Hacer nueva foto con cámara (no disponible en simulador)
        let nuevaFoto = UIAlertAction(title: "Hacer foto nueva", style: UIAlertActionStyle.default) { (action) in
            
            // En caso de estar disponible la imágen delegar función y presentarla permitiendo interacción al usuario
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.camera)
            {
                self.seleccionarImagen.delegate = self
                self.seleccionarImagen.sourceType = UIImagePickerControllerSourceType.camera
                self.seleccionarImagen.allowsEditing = true
                
                self.present(self.seleccionarImagen, animated: true, completion: nil)
            }
        }
        
        // Añadir las tres acciones a nuestra alerta de tipo ActionSheet y un botón de canceñar
        
        ActionSheet.addAction(verFoto)
        ActionSheet.addAction(seleccionarFoto)
        ActionSheet.addAction(nuevaFoto)
        ActionSheet.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        // Presentar finalmente al usuario el ActionSheet de forma animada
        self.present(ActionSheet, animated: true, completion: nil)
        
    }
    
    // Quitar la imágen más grande de la vista
    func quitarImagenCompleta(_ sender:UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    
    // Función para que almacenará la foto una vez el usuario ha terminado de seleccionarla
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // Una vez seleccionada carga la animación del Activity Indicator y llama al método para definir foto
        self.cargarImagen.startAnimating()
        definirFotoPerfil(self.fotoPerfil,imagen: image)
        
        if let imageData: Data = UIImagePNGRepresentation(self.fotoPerfil.image!)!{
            
            let profilePicStorageRef = storageRef.child("perfiles/\(self.UsuarioLogeado!.uid)/foto_perfil")
            
            let uploadTask = profilePicStorageRef.put(imageData, metadata: nil) {(metadata,error) in
                
                if(error == nil) {
                    let downloadUrl = metadata!.downloadURL()
                    
                    self.databaseRef.child("perfiles").child(self.UsuarioLogeado!.uid).child("foto_perfil").setValue(downloadUrl!.absoluteString)
                } else {
                    print(error?.localizedDescription)
                }
                self.cargarImagen.stopAnimating()
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Esconder teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func SobremiEditado(_ sender: Any) {
        // Mandamos los datos introducidos por el usuario en el textfield a la DB y actualizamos el nodo sobremi en el nodo principal de perfiles
        
        self.databaseRef.child("perfiles").child(self.UsuarioLogeado!.uid).child("sobremi").setValue(self.SobreMi.text)
    }
    
}

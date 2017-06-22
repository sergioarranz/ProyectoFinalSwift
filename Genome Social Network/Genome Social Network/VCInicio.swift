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
    
    var databaseRef = FIRDatabase.database().reference()
    var UsuarioLogueado: AnyObject?
    var DatosUsuarioLogueado: NSDictionary?
    
    var posts = [NSDictionary]()
    
    @IBOutlet var IconoCarga: UIActivityIndicatorView!
    @IBOutlet var TableViewInicio: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.IconoCarga.startAnimating()
        self.UsuarioLogueado = FIRAuth.auth()?.currentUser
        
        
        // Recoger los datos del usuario
        self.databaseRef.child("perfiles").child(self.UsuarioLogueado!.uid).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
            
            // Guardar los datos del usuario en la variable creada previamente
            self.DatosUsuarioLogueado = snapshot.value as? NSDictionary
            
            // Obtener todos los posts realizados por el usuario
            
            self.databaseRef.child("posts").child(self.UsuarioLogueado!.uid).observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
                
                 // Añadimos al final del diccionario donde almacenamos nuestros posts
                self.posts.append(snapshot.value as! NSDictionary)
                
                // Insertar cada post en celda individual en sección 0 (la única) con animación
                self.TableViewInicio.insertRows(at: [IndexPath(row:0,section:0)], with: UITableViewRowAnimation.automatic)
                
                // Parar animación del Activity Indicator una vez que ha sido cargado todo
                self.IconoCarga.stopAnimating()
                
            }){(error) in
                
                print(error.localizedDescription)
            }
            self.IconoCarga.stopAnimating()
        }
    }
    
    open func stopAnimating()
    {
        self.IconoCarga.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: VCInicioCell = tableView.dequeueReusableCell(withIdentifier: "VCInicioCell", for: indexPath) as! VCInicioCell
        
        /* Introducimos un post en la variable por cada fila.
         Importante: Al obtener los datos de la DB el más viejo viene en primer lugar, por tanto es necesario invertirlo para qu el último venga el primero y así sucesivamente*/
        let post = posts[(self.posts.count-1) - (indexPath.row)]["text"] as! String
        
        // Configurar celda con los datos definidos en VCInicioCell
        cell.configure(nil,NombreCompleto:self.DatosUsuarioLogueado!["nombre"] as! String,nickname:self.DatosUsuarioLogueado!["nick"] as! String,post:post)
        
        return cell
    }

    
    
}

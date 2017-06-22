//
//  VCInicioCell.swift
//  
//
//  Created by Sergio Arranz on 01/6/17.
//
//

import UIKit
// Hacemos la clase pública para que pueda ser accedida desde fuera
open class VCInicioCell: UITableViewCell {

    @IBOutlet weak var FotoPerfil: UIImageView!
    @IBOutlet weak var NombreCompleto: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var post: UITextView!
    //@IBOutlet weak var ImagenPost: UIImageView!
    
    //@IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // Función para configurar los datos con la foto de perfíl como opcional
    open func configure(_ FotoPerfil:String?,NombreCompleto:String,nickname:String,post:String)
    {
        // Asignación de datos al texto de los Labels
        self.post.text = post
        self.nickname.text = "@"+nickname
        self.NombreCompleto.text = NombreCompleto
        
        // Si la foto de perfil existe mostramos la imágen que vendrá por URL y la asignamos a la outlet
        if((FotoPerfil) != nil)
        {
            let DatosImagen = try? Data(contentsOf: URL(string:FotoPerfil!)!)
            self.FotoPerfil.image = UIImage(data:DatosImagen!)
        }
        else
        {
            self.FotoPerfil.image = UIImage(named:"logo_genome")
        }
        
    }

}

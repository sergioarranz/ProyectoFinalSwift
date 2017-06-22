//
//  VCPerfil.swift
//  Genome Social Network
//
//  Created by Sergio Arranz on 03/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit

class VCPerfil: UIViewController {

    @IBOutlet var postsContainer: UIView!
    @IBOutlet var mediaContainer: UIView!
    @IBOutlet var likesContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func mostrarComponentes(_ sender: AnyObject) {
        
        if(sender.selectedSegmentIndex == 0)
        {
            UIView.animate(withDuration: 0.5, animations: {
                
                self.postsContainer.alpha = 1
                self.mediaContainer.alpha = 0
                self.likesContainer.alpha = 0
            })
        }
        else if(sender.selectedSegmentIndex == 1)
        {
            UIView.animate(withDuration: 0.5, animations: {
                
                self.mediaContainer.alpha = 1
                self.postsContainer.alpha = 0
                self.likesContainer.alpha = 0
                
            })
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.likesContainer.alpha = 1
                self.postsContainer.alpha = 0
                self.mediaContainer.alpha = 0
            })
        }
    }


}

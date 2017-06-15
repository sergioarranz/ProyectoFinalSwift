//
//  ViewController.swift
//  Glory Days
//
//  Created by Sergio Arranz Sobrino on 15/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit

import AVFoundation
import Photos
import Speech


class ViewController: UIViewController {

    @IBOutlet var InfoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func askForPermissions(_ sender: UIButton) {
        
    }
    
    func askForPhotosPermissions() {
        PHPhotoLibrary.requestAuthorization { [unowned self] (authStatus) in
            DispatchQueue.main.async { // Manda al hilo principal todo el código que contiene para que pedir permisos o la etiqueta del else deje de ocurrir en hilos secundarios
            if authStatus == .authorized {
                self.askForRecordPermissions()
            } else {
                self.InfoLabel.text = "Has denegado el permiso de fotos. Por favor, activalo en los ajustes del dispositivo para continuar."
            }
            }
        }
    }

    func askForRecordPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { [unowned self] (allowed) in
            <#code#>
        }
        
    }
}


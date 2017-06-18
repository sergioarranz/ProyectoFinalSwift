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
    
    /* El sistema de permisos es asíncrono de modo que se realiza una petición y en un momento dado, cuando el usuario la acepta recibimos un callback/llamada de vuelta, estas no solo ocurren en el hilo principal si no que pueden ocurrir en cualquier hilo de ejecución, de modo que en algún callback se debe actualizar el hilo principal o la parte gráfica y evitar que ocurra en segundo plano. */
 
    // Creación de cadena de permisos a través de callbacks en vez de lanzar todas las peticiones de golpe. Estructura: Pedir permiso -> Esperar callback y así sucesivamente gestionando hilos de ejecución, recepción de respuestas, asignación de delegados, etc

    @IBAction func askForPermissions(_ sender: UIButton) {
        self.askForPhotosPermissions()
    }
    // Permisos de Fotos
    func askForPhotosPermissions() {
        
        PHPhotoLibrary.requestAuthorization { [unowned self] (authStatus) in // Pedir autorización a la clase de fotos pasando como handler el estado de la misma
            
            DispatchQueue.main.async { // Permite decidir en que hilo debe estar un bloque de código. Los completion handlers se ejecutan en segundo plano, por tanto  mandamos al hilo principal este bloque de modo que se actualize en tiempo real y no en hilos secundarios.
                
                if authStatus == .authorized { // Si el estado pasa a autorizado, sigue la cadena con el siguiente permiso o actualiza la etiqueta en caso contrario.
                    self.askForRecordPermissions()
                } else {
                    self.InfoLabel.text = "Has denegado el permiso de fotos. Por favor, activalo en los ajustes del dispositivo para continuar."
                }
            }
        }
        
    }
    // Permisos de Grabación
    func askForRecordPermissions() {
        AVAudioSession.sharedInstance().requestRecordPermission { [unowned self] (allowed) in
            
            DispatchQueue.main.async {
                if allowed {
                    self.askForTranscriptionPermissions()
                } else {
                    self.InfoLabel.text = "Has denegado el permiso de grabación. Por favor, activalo en los ajustes del dispositivo para continuar."
                }
            }
        }
        
    }
    // Permisos de Transcripción
    func askForTranscriptionPermissions() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] (authStatus) in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.authorizationComplete()
                } else {
                    self.InfoLabel.text = "Has denegado los permisos de transcripción de texto. Por favor, activalo en los ajustes del dispositivo para continuar."
                }
            }
        }
    }
    
    func authorizationComplete() {
        dismiss(animated: true)
    }
}


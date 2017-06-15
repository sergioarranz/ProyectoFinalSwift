//
//  ViewController.swift
//  Reconocimiento de voz
//
//  Created by Sergio Arranz on 13/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    var audioRecordingSession = AVAudioSession!.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recognizeSpeech()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recognizeSpeech() {
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in // Pedir autorización y conocer el tipo de estado (aprobada, denegada, etc)
            
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
             
                if let urlPath = Bundle.main.url(forResource: "audio", withExtension: "mp3") { // Busca en el paquete principal main() el archivo audio.mp3
                    let recognizer = SFSpeechRecognizer() // Objeto de tipo Reconocedor
                    let request = SFSpeechURLRecognitionRequest(url: urlPath) // Petición de almacenar el archivo almacenado en constante urlPath
                    
                    recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in // El reconocedor analiza la petición de forma asíncrona
                        if let error = error {
                            print("Algo ha ido mal: \(error.localizedDescription)")
                        } else {
                            self.textView.text = String(describing: result?.bestTranscription.formattedString) // Si no hay error, la TextView rellena con la mejor transcripción formateada del resultado que nos llega por la petición
                        }
                    })
                    
                }
            }
        }
    }
    
    func recordingAudioSetup() {
        //audioRecordingSession = AVAudioSession.sharedInstance()
        
    }
}


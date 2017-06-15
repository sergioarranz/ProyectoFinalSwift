//
//  ViewController.swift
//  Reconocimiento de voz
//
//  Created by Sergio Arranz on 13/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var textView: UITextView!
    var recordingSession: AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    
    let audioFileName : String = "audio-recordered.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //recognizeSpeech()
        recordingAudioSetup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recognizeSpeech() {
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in // Pedir autorización y conocer el tipo de estado (aprobada, denegada, etc)
            
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                
                
                let recognizer = SFSpeechRecognizer() // Objeto de tipo Reconocedor
                let request = SFSpeechURLRecognitionRequest(url: self.directoryURL()!) // Petición de almacenar el archivo almacenado en constante urlPath
                
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
    
    func recordingAudioSetup() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryRecord)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission({[unowned self] (allowed:Bool) in
                if allowed {
                    self.startRecording()
                } else {
                    print("Necesito permisos para usar el micrófono")
                }
            })
        } catch {
            print("Ha habido un error al configurar el audio recorder")
        }
        
    }
    
    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0] as URL
        do {
            return try documentsDirectory.appendingPathComponent(audioFileName)
        } catch {
            print("No hemos podido crear la estructura de carpetas para guardar el audio.")
        }
        return nil
    }
    func startRecording() {
        let settings = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000.0, AVNumberOfChannelsKey: 1 as NSNumber, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: directoryURL()!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.stopRecording), userInfo: nil, repeats: false)
        } catch {
            print("No se ha podido grabar el audio")
        }
    }
    func stopRecording() {
        audioRecorder.stop()
        audioRecorder = nil
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.recognizeSpeech), userInfo: nil, repeats: false)
    }
}


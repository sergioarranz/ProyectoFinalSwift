//
//  Images.swift
//  Glory Days
//
//  Created by Sergio Arranz Sobrino on 15/6/17.
//  Copyright © 2017 Sergio Arranz Sobrino. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Speech

import CoreSpotlight
import MobileCoreServices

private let reuseIdentifier = "cell"

class Images: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, UISearchBarDelegate {
    
    var memories : [URL] = [] // Array de objetos de tipo URL guardar las posiciones de los Recuerdos
    var filteredMemories : [URL] = []
    var currentMemory : URL!
    
    var audioPlayer : AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var recordingURL : URL!
    
    var searchQuery : CSSearchQuery?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recordingURL = try? getDocumentsDirectory().appendingPathComponent("memory-recording.m4a")
        
        
        self.loadMemories()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addImagePressed))
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Recomendable hacer transiciones como esta entre ViewControllers aquí y no antes de que se cargue la vista (viewDidLoad) puesto que da problemas a nivel de compilador.
        self.checkForGrantedPermissions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForGrantedPermissions() { // Guarda cada permiso si el estado es autorizado, los junta en una variable y transiciona al VC de Terms si alguno de ellos no está en dicho estado
        let photosAuth : Bool = PHPhotoLibrary.authorizationStatus() == .authorized
        let recordingAuth : Bool = AVAudioSession.sharedInstance().recordPermission() == .granted
        let transcriptionAuth : Bool = SFSpeechRecognizer.authorizationStatus() == .authorized
        
        let authorized = photosAuth && recordingAuth && transcriptionAuth
        
        if !authorized {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ShowTerms") { // Instanciar Vista de términos de forma segura con optional binding
                navigationController?.present(vc, animated: true) // Presenta el VC embebido en el NavigationController
            }
        }
    }
    
    func loadMemories() {
        self.memories.removeAll() // Vacía el array para evitar duplicidad de información
        
        guard let files = try? FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil, options: []) else { // Recoge algún archivo del DocumentsDirectory
            return
        }
        
        for file in files { // Busca todos los archivos contenidos en DocumentsDirectory
            
            let fileName = file.lastPathComponent // Recoge el nombre del archivo, no es necesario un Optional Binding puesto que devuelve un String vacio si no tiene nombre
            
            if fileName.hasSuffix(".thumb") { // Localiza la miniatura, quita extensión y añade al array la URL que contiene solo el nombre del archivo
                let noExtension = fileName.replacingOccurrences(of: ".thumb", with: "")
                
                if let memoryPath = try? getDocumentsDirectory().appendingPathComponent(noExtension) {
                    memories.append(memoryPath)
                }
                
            }
        }
        filteredMemories = memories
        collectionView?.reloadSections(IndexSet(integer: 1)) // Recarga la sección en el Index 1 puesto que la sección 0 es el SearchBar
    }
    
    func getDocumentsDirectory() -> URL { // Devuelve la carpeta donde se guardarán todos los archivos
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // Almacena en paths los archivos del directorio de documentos del usuario
        let documentsDirectory = paths[0] // Nos quedamos solo con el primero que será el directorio donde se guardarán y cargarán las imágenes para mostrarlas en el CVController
        
        return documentsDirectory
    }
    
    func addImagePressed() { // Creación del selector de fotos y presentación a través del NC
        
        let vc = UIImagePickerController()
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { // Añade una imágen y recarga
        if let theImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.addNewMemory(image: theImage)
            self.loadMemories()
            
            dismiss(animated: true)
        }
    }
    
    func addNewMemory(image: UIImage){ // Guardar imágen y miniatura en disco con redimensión en el caso de la última
        let memoryName = "memory-\(Date().timeIntervalSince1970)"
        
        let imageName = "\(memoryName).jpg"
        let thumbName = "\(memoryName).thumb"
        
        do {
            let imagePath = try getDocumentsDirectory().appendingPathComponent(imageName)
            
            if let jpegData = UIImageJPEGRepresentation(image, 80) {
                try jpegData.write(to: imagePath, options: [.atomicWrite])
            }
            
            if let thumbnail = resizeImage(image: image, to: 200) {
                let thumbPath = try getDocumentsDirectory().appendingPathComponent(thumbName)
                
                if let jpegData = UIImageJPEGRepresentation(thumbnail, 80) {
                    try jpegData.write(to: thumbPath, options: [.atomicWrite])
                }
            }
            
        } catch {
            print("Ha fallado la escritura en disco")
        }
        
        
    }
    
    func resizeImage(image: UIImage, to width: CGFloat) -> UIImage? {
        let scaleFactor = width / image.size.width // Disminuyo anchura
        let height = image.size.height * scaleFactor // Disminuyo altura a partir de la escala de la anchura
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0) // Redimensiona imágen con anchura y altura que nos llega por parámetro y con la escala manual que hemos definido anteriormente
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height)) // Dibuja en un rectángulo la imágen original con with y height por parámetro
        let newImage = UIGraphicsGetImageFromCurrentImageContext() // Extraemos la nueva imágen
        
        UIGraphicsEndImageContext() // Finaliza la edición
        
        return newImage
    }
    
    func imageURL(for memory: URL) -> URL { // Recibo un objeto del array de recuerdos y añado la extensión para la imágen
        return try! memory.appendingPathExtension("jpg")
    }
    
    func thumbnailURL(for memory: URL) -> URL { // Recibo un objeto del array de recuerdos y añado la extensión para la miniatura
        return try! memory.appendingPathExtension("thumb")
    }
    
    func audioURL(for memory: URL) -> URL { // Recibo un objeto del array de recuerdos y añado la extensión para el audio
        return try! memory.appendingPathExtension("m4a")
    }
    
    func transcriptionURL(for memory: URL) -> URL { // Recibo un objeto del array de recuerdos y añado la extensión para la transcripción
        return try! memory.appendingPathExtension("txt")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0 {
            return 0
        } else {
            return self.filteredMemories.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        
        let memory = self.filteredMemories[indexPath.row]
        let memoryName = self.thumbnailURL(for: memory).path
        let image = UIImage(contentsOfFile: memoryName)
        cell.imageView.image = image
        
        if cell.gestureRecognizers == nil {
            
            let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.memoryLongPressed))
            recognizer.minimumPressDuration = 0.3
            cell.addGestureRecognizer(recognizer)
            
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 4
            cell.layer.cornerRadius = 10
            
        }
        return cell
    }
    
    func memoryLongPressed(sender : UILongPressGestureRecognizer) {
        if sender.state == .began {
            let cell = sender.view as! ImageCell
            
            if let index = collectionView?.indexPath(for: cell) {
                self.currentMemory = self.filteredMemories[index.row]
                
                self.startRecordingMemory()
            }
        }
        
        if sender.state == .ended {
            self.finishRecordingMemory(success: true)
        }
    }
    
    func startRecordingMemory(){
        
        audioPlayer?.stop()
        
        collectionView?.backgroundColor = UIColor(red: 0.6, green: 0.0, blue: 0.0, alpha: 1.0)
        
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try recordingSession.setActive(true)
            
            let recordingSettings = [ AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                                      AVSampleRateKey : 44100,
                                      AVNumberOfChannelsKey : 2,
                                      AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: recordingSettings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
        } catch let error {
            print(error)
            finishRecordingMemory(success: false)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecordingMemory(success: false)
        }
    }
    
    func finishRecordingMemory(success: Bool) {
        
        collectionView?.backgroundColor = UIColor(red: 148.0/255.0, green: 125.0/255, blue: 158.0/255, alpha: 1.0)
        
        audioRecorder?.stop()
        
        if success {
            do {
                let memoryAudioURL = try self.currentMemory.appendingPathExtension("m4a")
                
                let fileManager = FileManager.default
                
                if fileManager.fileExists(atPath: memoryAudioURL.path) {
                    try fileManager.removeItem(at: memoryAudioURL)
                }
                
                try fileManager.moveItem(at: recordingURL, to: memoryAudioURL)
                
                self.transcribeAudioToText(memory: self.currentMemory)
                
            } catch let error {
                print("Ha habido un error \(error)")
            }
        }
        
        
    }
    
    func transcribeAudioToText(memory : URL) {
        
        let audio = audioURL(for: memory)
        let transcription = transcriptionURL(for: memory)
        
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: audio)
        
        recognizer?.recognitionTask(with: request, resultHandler: { [unowned self] (result, error) in
            
            guard let result = result else {
                print("Ha habido el siguiente error: \(error)")
                return
            }
            
            if result.isFinal {
                
                let text = result.bestTranscription.formattedString
                
                do {
                    try text.write(to: transcription, atomically: true, encoding: String.Encoding.utf8)
                    self.indexMemory(memory: memory, text: text)
                } catch {
                    print("Ha habido un error al guardar la transcripción")
                }
            }
            
            
        })
    }
    
    func indexMemory(memory: URL, text: String){
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = "Recuerdo de Glory Days"
        attributeSet.contentDescription = text
        attributeSet.thumbnailURL = thumbnailURL(for: memory)
        
        let item = CSSearchableItem(uniqueIdentifier: memory.path, domainIdentifier: "com.SergioArranz", attributeSet: attributeSet)
        
        item.expirationDate = Date.distantFuture
        
        CSSearchableIndex.default().indexSearchableItems([item]) { (error) in
            if let error = error {
                print("Ha habido un problema al indexar \(error)")
            } else {
                print("Hemos podido indexar correctamente el texto: \(text)")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memory = self.filteredMemories[indexPath.row]
        
        let fileManager = FileManager.default
        
        do {
            let audioName = audioURL(for: memory)
            let transcriptionName = transcriptionURL(for: memory)
            
            if fileManager.fileExists(atPath: audioName.path) {
                self.audioPlayer = try AVAudioPlayer(contentsOf: audioName)
                self.audioPlayer?.play()
            }
            
            if fileManager.fileExists(atPath: transcriptionName.path) {
                let contents = try String(contentsOf: transcriptionName)
                print(contents)
            }
        } catch {
            print("Error al cargar el audio para reproducir")
        }
    }
    
    
    func filterMemories(text: String){
        
        guard text.characters.count > 0 else {
            self.filteredMemories = self.memories
            
            UIView.performWithoutAnimation {
                collectionView?.reloadSections(IndexSet(integer: 1))
            }
            
            return
        }
        
        
        var allTheItems : [CSSearchableItem] = []
        
        searchQuery?.cancel()
        
        let queryString = "contentDescription == \"*\(text)*\"c"
        self.searchQuery = CSSearchQuery(queryString: queryString, attributes: nil)
        self.searchQuery?.foundItemsHandler = { items in
            allTheItems.append(contentsOf: items)
        }
        self.searchQuery?.completionHandler = { error in
            DispatchQueue.main.async { [unowned self] in
                self.activateFilter(matches: allTheItems)
            }
        }
        self.searchQuery?.start()
    }
    
    func activateFilter(matches: [CSSearchableItem]) {
        
        self.filteredMemories = matches.map { (item) in
            let uniqueID = item.uniqueIdentifier
            let url = URL(fileURLWithPath: uniqueID)
            return url
        }
        
        UIView.performWithoutAnimation {
            collectionView?.reloadSections(IndexSet(integer: 1))
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterMemories(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

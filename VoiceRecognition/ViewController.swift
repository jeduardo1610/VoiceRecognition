//
//  ViewController.swift
//  VoiceRecognition
//
//  Created by Jorge Eduardo on 16/08/17.
//  Copyright © 2017 Jorge Eduardo. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var textView: UITextView!
    var audioRecordSession : AVAudioSession!
    let audioFileName : String = "audio-recordered.m4a"
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //recognizeSpeech()
        recordAudioSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDialog(title: String?, message : String?){
        
        if let title = title, let message = message {
            let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction : UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            showDialog(title: "Voice Recognition", message: "Something went terribly wrong")
        }
        
    }


    func recognizeSpeech(){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            let auth = authStatus.rawValue

            switch auth {
            case 0://notDetermined
                print("notDetermined")
                self.showDialog(title: "Voice Recognition", message: "Unknown access\nPlease go to settings and enable permissions for this app")
            case 1: //denied
                print("Denied")
                self.showDialog(title: "Voice Recognition" , message: "Access Denied\nPlease go to settings and enable permissions for this app")
            case 3://authorized
                print("authorized")
                    
                let recognizer = SFSpeechRecognizer()
                let request = SFSpeechURLRecognitionRequest(url: self.directoryURL()!)
                recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                    
                    if let error = error {
                        print ("Something went terribly wrong \(error.localizedDescription)")
                    } else {
                        self.textView.text = String(describing: result?.bestTranscription.formattedString)
                    }
                    
                })
                
            default:
                self.showDialog(title: nil, message: nil)
            }
            
            /*if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                
                if let path = Bundle.main.url(forResource: "audio", withExtension: "mp3") {
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                        
                        if let error = error {
                            print ("Something went terribly wrong \(error.localizedDescription)")
                        } else {
                            self.textView.text = String(describing: result?.bestTranscription.formattedString)
                        }
                        
                    })
                    
                }
                
            } else {
                print("Unable to access to resources")
            }*/
            
        }
    }
    
    func recordAudioSetup(){
        
        audioRecordSession = AVAudioSession.sharedInstance()
        
        do {
            try audioRecordSession.setCategory(AVAudioSessionCategoryRecord)
            try audioRecordSession.setActive(true)
            
            audioRecordSession.requestRecordPermission({[unowned self] (permissionGranted : Bool) in
                if permissionGranted {
                    
                    self.startRecording()
                    
                } else {
                    self.showDialog(title: "Setting Up Recorder", message: "Access Denied\nPlease go to settings and enable permissions for this app")
                }
            })
            
        } catch {
            print ("Something went terribly wrong while setting up the recorder")

        }
        
    }
    
    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0] as URL
        return documentsDirectory.appendingPathComponent(audioFileName)
    }
    
    func startRecording() {
        
        let settings : [String : Any] = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey : 12000.0,
                        AVNumberOfChannelsKey : 1 as NSNumber,
                        AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue]
        do {
            audioRecorder = try AVAudioRecorder(url: directoryURL()!, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.stopRecording), userInfo: nil, repeats: false)

        } catch {
            self.showDialog(title: "Audio Recording", message: "Unable to start recording audio")
        }
        
    }
    
    func stopRecording(){
        audioRecorder.stop()
        audioRecorder = nil
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.recognizeSpeech), userInfo: nil, repeats: false)
    }
    
}


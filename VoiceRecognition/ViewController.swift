//
//  ViewController.swift
//  VoiceRecognition
//
//  Created by Jorge Eduardo on 16/08/17.
//  Copyright © 2017 Jorge Eduardo. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recognizeSpeech()
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
                self.showDialog(title: "Voice Recognition", message: "Not Determined")
            case 1: //denied
                print("Denied")
                self.showDialog(title: "Voice Recognition" , message: "Access Denied\nPlease go to settings and enable permissions for this app")
            case 3://authorized
                print("authorized")
                
                if let path = Bundle.main.url(forResource: "audio", withExtension: "mp3") {
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                        
                        if let error = error {
                            print ("Something went terribly wrong \(error.localizedDescription)")
                        } else {
                            self.textView.text = String(describing: result?.bestTranscription.formattedString)
                            print("---------------------RESULT--------------------")
                            print(String(describing: result?.bestTranscription.formattedString))
                        }
                        
                    })
                    
                }
                
            default:
                showDialog(title: nil, message: nil)
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
    
}


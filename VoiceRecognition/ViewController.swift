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


    func recognizeSpeech(){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                
                if let path = Bundle.main.url(forResource: "audio", withExtension: "mp3") {
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                        
                        if let error = error {
                            print (error.localizedDescription)
                        } else {
                            self.textView.text = result?.bestTranscription.formattedString
                        }
                        
                    })
                    
                }
                
            } else {
                print("Unable to access to resources")
            }
            
        }
    }
    
}


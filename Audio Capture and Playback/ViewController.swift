//
//  ViewController.swift
//  Audio Capture and Playback
//
//  Created by Jonah Zukosky on 3/22/19.
//  Copyright © 2019 Zukosky, Jonah. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    
    @IBOutlet weak var recordButton: UIBarButtonItem!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var audioPlayer : AVAudioPlayer!
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("Accepted")
            }
        }
    }

    @IBAction func addNewRecording(_ sender: Any) {
        startRecording()
//        recordingSession = AVAudioSession.sharedInstance()
//
//
//        let session = AVAudioSession.sharedInstance()
//        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
//            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
//                if granted {
//                    print("granted")
//                    if self.audioRecorder == nil {
//                        self.startRecording()
//                        self.recordButton.title = "Stop"
//
//                    } else {
//                        self.finishRecording(success: true)
//                        self.recordButton.title = "Record"
//                    }
//
//                    do {
//                        try session.setCategory(.playAndRecord, mode: .default)
//                        try session.setActive(true)
//                    }
//                    catch {
//
//                        print("Couldn't set Audio session category")
//                    }
//                } else{
//                    print("not granted")
//                }
//            })
//        }
    }

    func startRecording() {
        if audioRecorder == nil {

            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                print("recording")
                audioRecorder.record()
                
                recordButton.title = "Stop"
            } catch {
                finishRecording(success: false)
            }
        } else {
            audioRecorder.stop()
            audioRecorder = nil
            
            recordButton.title = "Record"
        }
    }
    
    func finishRecording(success: Bool) {
        print("stopping recording with \(success)")
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playAudio()
    }
    
    @IBAction func profilesPressed(_ sender: Any) {
        
    }
}

extension ViewController {

    func playAudio() {
        if(isPlaying) {
            print("stopping playing")
            audioPlayer.stop()

            isPlaying = false
        }
        else {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent("recording.m4a") {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    print("FILE AVAILABLE")
                    //prepare_play()
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: pathComponent)
                        audioPlayer.delegate = self
                    } catch {
                        print("couldn't prepare audioPlayer")
                    }
                    
                    audioPlayer.prepareToPlay()
                    print("starting playing")
                    audioPlayer.play()
                    isPlaying = true
                } else {
                    print("FILE NOT AVAILABLE")
                }
            } else {
                print("FILE PATH NOT AVAILABLE")
            }
        }
    }
    
    
    func prepare_play() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.m4a"))
            //audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch {
            print("Error")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        print("finished playing")
    }
    
}


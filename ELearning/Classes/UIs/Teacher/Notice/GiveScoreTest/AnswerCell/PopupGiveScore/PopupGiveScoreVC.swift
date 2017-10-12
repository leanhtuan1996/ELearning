//
//  PopupGiveScoreVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/11/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import AVFoundation

class PopupGiveScoreVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnListen: UIButton!
    @IBOutlet weak var txtScore: UITextField!
    
    
    var idTest: String?
    var idStudent: String?
    var questionName: String?
    var answer = AnswerObject()
    let loading = UIActivityIndicatorView()
    var dataAnswerVoiceURL: URL?
    
    var isListening: Bool = false
    var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 5
        setUpPlayVoice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblName.text = questionName
    }

    
    @IBAction func btnListenTapped(_ sender: Any) {
        if isListening {
            //stop
            stopVoice()
            return
        }
        //start listen
        playVoice()
        
    }
    @IBAction func btnDone(_ sender: Any) {
        
        guard let testId = self.idTest, let questionId = self.answer.questionId, let studentId = self.idStudent, txtScore.hasText == true, let scoreString = txtScore.text else {
            print("Fail")
            return
        }
        
        guard let score = scoreString.toInt() else {
            self.showAlert("Score must be a number", title: "Error", buttons: nil)
            return
        }
        
        loading.showLoadingDialog(self)
        TestServices.shared.giveScore(withTestId: testId, withStudentId: studentId, withQuestionId: questionId, withScore: score) { (error) in
            self.loading.stopAnimating()
            if let error = error {
                self.showAlert(error, title: "Give Score has been failed", buttons: nil)
                return
            }
            let returnButton = UIAlertAction(title: "Back to main", style: UIAlertActionStyle.default, handler: { (btn) in
                self.closePopup()
            })
            self.showAlert("Give score has been successfully!", title: "Success", buttons: [returnButton])
        }
        
    }
    
    func closePopup() {
        self.didMove(toParentViewController: self)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }

    @IBAction func btnCloseTapped(_ sender: Any) {
        closePopup()
    }
}

extension PopupGiveScoreVC: AVAudioPlayerDelegate {
    
    func setUpPlayVoice() {
        //set up audio session
        audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        } catch {
            print("ERROR")
        }
    }
    
    func playVoice() {
        self.isListening = true
        
        guard let dataVoiceURL = self.dataAnswerVoiceURL else {
            self.showAlert("Answer voice not found", title: "Error", buttons: nil)
            return
        }
        
        if !FileManager.default.fileExists(atPath: dataVoiceURL.path) {
            self.showAlert("File Answer Voice not exist", title: "Error", buttons: nil)
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: dataVoiceURL, fileTypeHint: AVFileTypeMPEGLayer3)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            print("Prepare play audio Okay")
        } catch let error as NSError {
            print(error)
            return
        } catch {
            print("Error not found")
            return
        }
       
        audioPlayer.play()
        btnListen.setTitle("Tap to stop", for: UIControlState.normal)
    }
    
    func stopVoice() {
        
        if audioPlayer != nil {
            self.audioPlayer.stop()
            self.audioPlayer = nil
        }
        
        self.isListening = false
        btnListen.setTitle("Tap to re-play", for: UIControlState.normal)
    }
}

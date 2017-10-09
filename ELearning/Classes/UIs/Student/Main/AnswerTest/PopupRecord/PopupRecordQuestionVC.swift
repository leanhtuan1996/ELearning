//
//  PopupRecordQuestionVC.swift
//  ELearning
//
//  Created by Lê Anh Tuấn on 10/8/17.
//  Copyright © 2017 Lê Anh Tuấn. All rights reserved.
//

import UIKit
import AVFoundation

class PopupRecordQuestionVC: UIViewController {
    
    var question: QuestionObject?
    var idTest: String?
    var pathAudio: URL?
    var isRecording: Bool = false
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?
    var timerMeter: Timer?
    let loading = UIActivityIndicatorView()
    var delegate: TestDataDelegate?
    
    @IBOutlet weak var lblAudioTimer: UILabel!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var lblQuestion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 5
        showAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let question = self.question {
            lblQuestion.text = question.question
            setUpRecord()
        }
    }
    
    @IBAction func btnDone(_ sender: Any) {
        if !isRecording {
            
            guard let testId = self.idTest, let questionId = self.question?.id else {
                return
            }
            loading.showLoadingDialog(self)
            TestServices.shared.answerTest(testId: testId, questionId: questionId, completionHandler: { (error) in
                self.loading.stopAnimating()
                if let error = error {
                    self.showAlert(error, title: "Answer question has been failed", buttons: nil)
                    return
                }
                let buttonBack = UIAlertAction(title: "Continue to answer other questions", style: UIAlertActionStyle.default, handler: { (btn) in
                    self.closeAnimate()
                })
                self.showAlert("Answer the question successfully", title: "Success", buttons: [buttonBack])
            })
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        closeAnimate()
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.alpha = 1
        }
    }
    
    func closeAnimate() {
        if !isRecording {
            UIView.animate(withDuration: 0.1, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0
            }) { (finish) in
                if finish {
                    let sb = self.parent
                    self.view.removeFromSuperview()
                    //self.willMove(toParentViewController: nil)
                    
                    sb?.willMove(toParentViewController: sb)
                    self.removeFromParentViewController()
                }
            }
        } else {
            showAlert("You are recording!", title: "error", buttons: nil)
        }
        
    }
    
    @IBAction func btnRecordTapped(_ sender: Any) {
        if isRecording {
            finishRecording()
        } else {
            startRecording()
        }
    }
    
}

extension PopupRecordQuestionVC: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func setUpRecord() {
        
        guard let idQuestion = self.question?.id else {
            print("Id question not found")
            return
        }
        
        //Request permissions
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
            //Request permissions
            recordingSession.requestRecordPermission({ (isSuccess) in
                if isSuccess {
                    print("Xin quyền truy cập microphone thành công")
                } else {
                    //failed
                    print("Xin quyền truy cập microphone thất bại")
                }
            })
            
        } catch {
            print("ERROR")
        }
        
        //get path to save audio
        let path = Helpers.getDucumentDirectory().appendingPathComponent("\(idQuestion).m4v")
        self.pathAudio = path
        
        //setting audioRecorder
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey : 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        //set setting to audioRecorder
        do {
            audioRecorder =  try AVAudioRecorder.init(url: path, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            
        } catch {
            print("Recording failed")
            finishRecording()
        }
    }
    
    func startRecording() {
        
        switch recordingSession.recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            
            self.isRecording = true
            audioRecorder?.record()
            btnRecord.setTitle("Tap to stop", for: UIControlState.normal)
            timerMeter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateAudioMeter) , userInfo: nil, repeats: true)
        default:
            self.showAlert("App can use microphone", title: "error", buttons: nil)
            break
        }
    }
    func finishRecording() {
        
        btnRecord.setTitle("Tap to re-record", for: UIControlState.normal)
        audioRecorder?.stop()
        self.isRecording = false
    }
        
    func updateAudioMeter() {
        
        guard let audioRecorder = self.audioRecorder else {
            return
        }
        
        if isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            DispatchQueue.main.async {
                self.lblAudioTimer.text = totalTimeString
                //self.audioRecorder.updateMeters()
            }
        }
    }
}

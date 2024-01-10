//
//  SpeechViewController.swift
//  RecordApp
//
//  Created by se-ryeong on 1/9/24.
//

import UIKit
import Speech

class SpeechViewController: UIViewController {
    // 한국어 설정
    private let speechRecognizer = SFSpeechRecognizer(locale: .init(identifier: "ko-KR"))
    // 음성인식 요청 처리 객체
    private var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    // 음성인식 요청 결과 제공 객체
    private var recognitionTask: SFSpeechRecognitionTask?
    // 소리만 인식하는 오디오 엔진 객체
    private var audioEngine = AVAudioEngine()
    
    private lazy var button : UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("말하기", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        
        return btn
    }()
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray5
        
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addSubViews()
        buttonLayout()
        textViewLayout()
        
        speechRecognizer?.delegate = self
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func addSubViews() {
        view.addSubview(button)
        view.addSubview(textView)
    }
    
    func textViewLayout() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.heightAnchor.constraint(equalToConstant: 250),
            textView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func buttonLayout() {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func buttonTapped() {
        if audioEngine.isRunning { // 현재 음성인식이 수행중이라면
            audioEngine.stop() // 오디오 입력을 중단한다.
            recognitionRequest?.endAudio() // 음성인식도 중단
            button.isEnabled = false
            button.setTitle("말하기", for: .normal)
         } else {
            startRecording()
            button.setTitle("말하기 멈추기", for: .normal)
         }
    }
    
    func speechToText() {
        
    }
}

extension SpeechViewController: SFSpeechRecognizerDelegate {
    
    func startRecording() {
        // 인식 작업이 실행 중인지 확인. 이 경우 작업과 인식 취소
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // 오디오 녹음 준비 할 AVAudioSession 생성
        // 세션의 범주를 녹음, 측정 모드로 설정하고 활성화
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set")
        }
        
        // 음성인식 요청 객체 생성
        // 객체 생성, 오디오 데이터를 Apple 서버에 전달하는데 사용
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // 오디오 입력이 있는지 확인
        // inputNode로 오디오 입력 수행되기 때문
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        // true면 사용자 음성 부분의 결과가 보고됨 (최종은 아님)
        recognitionRequest.shouldReportPartialResults = true
        
        // 인식을 시작하려면 recognitionTask호출
        self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            // 부울을 정의하여 인식이 최종인지 확인
            var isFinal = false
            
            if result != nil {
                // 결과가 nil이 아니면 가장 정확한 번역을 텍스트뷰에 작성, isFinal을 true로 설정
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            // 오류 없거나 최종 결과 나오면 audioEnine(오디오 입력)중지, 동시에 녹음 시작 활성화
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.button.isEnabled = true
            }
        })
        
        // recognitionRequest에 오디오 입력 추가, 인식 작업 시작 후에는 오디오 입력 추가 가능, 오디오 프레임워크는 오디오 입력이 추가되는 즉시 인식 시작
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            
            // 인식이 되는 즉시 recognitionRequest에 음성 추가
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start")
        }
        
        self.textView.text = "말해보세요"
        
    }
    
}

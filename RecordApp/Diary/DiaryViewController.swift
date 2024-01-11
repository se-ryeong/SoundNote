//
//  DiaryViewController.swift
//  RecordApp
//
//  Created by se-ryeong on 2023/12/28.
//

import UIKit
import SnapKit
import Speech

final class DiaryViewController : UIViewController {
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Record your feelings today".localized
        label.numberOfLines = 2
        label.textColor = .black
        label.font = .title
        
        return label
    }()
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "Color")
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.borderWidth = 0.5
        
        return textView
    }()
    
    private var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Recording".localized, for: .normal)
        button.setTitleColor(UIColor(named: "Color2"), for: .normal)
        button.backgroundColor = UIColor(named: "Color")
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    
    private var calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Calendar"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.layer.cornerRadius = button.layer.frame.size.width/2
        button.backgroundColor = UIColor(named: "Color3")
        button.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        
        return button
    }()
        
    private var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Search"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.layer.cornerRadius = button.layer.frame.size.width/2
        button.backgroundColor = UIColor(named: "Color3")
        
        return button
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .title
        label.textColor = UIColor(named: "Color1")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM . dd"
        label.text = formatter.string(from: Date())
        
        return label
    }()
    
    @objc private func calendarButtonTapped(_ sender: UIButton) {
        // CalendarViewController를 초기화하고 네비게이션 컨트롤러에 푸시(push)하는 예시
        let calendarVC = CalendarViewController()
        self.navigationController?.pushViewController(calendarVC, animated: true)
        
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        setUI()
        setLayout()
        setNavigationBar()
        
        speechRecognizer?.delegate = self
        recordButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func setNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
    }
    
    func setUI() {
        view.addSubviews([subTitleLabel, textView, recordButton, calendarButton, searchButton, dateLabel])
    }
    
    func setLayout() {
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(32)
        }
        
        recordButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(130)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
            $0.height.equalTo(40)
        }
        
        calendarButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-32)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.width.equalTo(50)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalTo(calendarButton.snp.leading).offset(-12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.width.equalTo(50)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.top).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: STT설정
    
    // 한국어 설정
    private let speechRecognizer = SFSpeechRecognizer(locale: .init(identifier: "ko-KR"))
    // 음성인식 요청 처리 객체
    private var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    // 음성인식 요청 결과 제공 객체
    private var recognitionTask: SFSpeechRecognitionTask?
    // 소리만 인식하는 오디오 엔진 객체
    private var audioEngine = AVAudioEngine()
    
    @objc func buttonTapped() {
        if audioEngine.isRunning { // 현재 음성인식이 수행중이라면
            audioEngine.stop() // 오디오 입력을 중단한다.
            recognitionRequest?.endAudio() // 음성인식도 중단
            recordButton.isEnabled = false
            recordButton.setTitle("Recording".localized, for: .normal)
         } else {
            startRecording()
             recordButton.setTitle("Stop recording".localized, for: .normal)
         }
    }
}

extension DiaryViewController: SFSpeechRecognizerDelegate {
    
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
                self.recordButton.isEnabled = true
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
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let calendarVC = CalendarViewController()
        
    }
}

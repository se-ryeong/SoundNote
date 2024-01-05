//
//  DiaryViewController.swift
//  RecordApp
//
//  Created by se-ryeong on 2023/12/28.
//

import UIKit
import SnapKit

final class DiaryViewController : UIViewController {
    
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Cancel"), for: .normal)
        
        return button
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Save"), for: .normal)
        
        return button
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 감정을\n기록해 보세요"
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont(name: "Pretendard-Regular", size: 18)
        
        return label
    }()
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "Color")
        textView.layer.cornerRadius = 10
        
        return textView
    }()
    
    private var recordButton: UIButton = {
        let button = UIButton()
        button.setTitle("녹음하기", for: .normal)
        button.setTitleColor(UIColor(named: "Color2"), for: .normal)
        button.backgroundColor = UIColor(named: "Color")
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 1, height: 2)
        
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        setUI()
        setLayout()
    }
    
    func setUI() {
        view.addSubviews([subTitleLabel, saveButton, cancelButton, textView, recordButton])
    }
    
    func setLayout() {
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(32)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        saveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-32)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(cancelButton.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-32)
            $0.height.equalTo(500)
        }
        
        recordButton.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(130)
        }
    }
}

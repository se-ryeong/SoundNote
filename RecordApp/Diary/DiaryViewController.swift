//
//  DiaryViewController.swift
//  RecordApp
//
//  Created by se-ryeong on 2023/12/28.
//

import UIKit
import SnapKit

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
        button.setTitle("record".localized, for: .normal)
        button.setTitleColor(UIColor(named: "Color2"), for: .normal)
        button.backgroundColor = UIColor(named: "Color")
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        setUI()
        setLayout()
    }
    
    func setUI() {
        view.addSubviews([subTitleLabel, textView, recordButton])
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
    }
}


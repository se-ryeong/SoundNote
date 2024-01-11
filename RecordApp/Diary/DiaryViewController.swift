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
    
    private var calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Calendar"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        button.layer.cornerRadius = button.layer.frame.size.width/2
        button.backgroundColor = UIColor(named: "Color3")
        button.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        
        return button
    }()
        
    private var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Search"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
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
            $0.height.width.equalTo(60)
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalTo(calendarButton.snp.leading).offset(-12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.width.equalTo(60)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(textView.snp.top).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
}

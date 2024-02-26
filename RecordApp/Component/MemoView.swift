//
//  MemoView.swift
//  RecordApp
//
//  Created by se-ryeong on 1/18/24.
//

import UIKit

final class MemoView: UIView {
    var textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = .body3
        
        return view
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        self.backgroundColor = UIColor(named: "Color")
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.borderWidth = 0.5
    }
    
    private func setUI() {
        self.addSubviews([dateLabel, textView])
    }
    
    private func setLayout() {
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}

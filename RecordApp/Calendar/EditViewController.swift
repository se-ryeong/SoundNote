//
//  EditViewController.swift
//  RecordApp
//
//  Created by se-ryeong on 4/19/24.
//

import UIKit

protocol EditViewControllerDelegate: AnyObject {
    func didFinishEdit()
}

class EditViewController: UIViewController {
    private var content: Content
    private let contentManager = ContentManager()
    
    weak var delegate: EditViewControllerDelegate?
    
    private let memoView = MemoView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body3
        label.textColor = .brown
        
        return label
    }()
    
    private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수정하기", for: .normal)
        button.setTitleColor(.init(resource: .color2), for: .normal)
        button.backgroundColor = .init(resource: .color)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.systemGray5.cgColor
        button.layer.borderWidth = 0.5
        
        return button
    }()
    
    init(content: Content) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .init(resource: .background)
        
        let date = content.createDate?.formatted(style: .monthDay)
        memoView.textView.text = content.memo
        memoView.dateLabel.text = ""
        titleLabel.text = "\(date ?? "") 기록 변경"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        
        saveButton.addAction(.init(handler: { [weak self] _ in
            guard let self else { return }
            
            contentManager.update(content: content, completion: { [weak self] content in
                content.memo = self?.memoView.textView.text
                self?.dismiss(animated: true) { [weak self] in
                    self?.delegate?.didFinishEdit()
                }
            })
        }), for: .touchUpInside)
    }
    
    private func setUI() {
        view.addSubviews([titleLabel, memoView, saveButton])
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        memoView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(saveButton.snp.top).offset(-18)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(130)
        }
    }
}

import RealmSwift

#Preview(traits: .portrait) {
    EditViewController(content: .init(id: ObjectId.generate(), memo: "메모프리뷰", createDate: .now))
}

//
//  MemoCell.swift
//  RecordApp
//
//  Created by se-ryeong on 1/18/24.
//

import UIKit

class MemoCell: UICollectionViewCell {
    static let identifier = "MemoCell"
    
    let memoView: MemoView = {
        let view = MemoView()
        
        return view
    }()
    
    private var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Edit"), for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
//        addSubview(memoView)
        addSubviews([memoView, editButton])
    }
    
    func setLayout() {
        memoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalTo(memoView.snp.trailing).offset(-16)
            $0.top.equalTo(memoView.snp.top).offset(16)
            $0.height.equalTo(10)
        }
    }
}

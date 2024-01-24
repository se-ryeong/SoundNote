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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubview(memoView)
    }
    
    func setLayout() {
        memoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

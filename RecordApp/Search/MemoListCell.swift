//
//  MemoListCell.swift
//  RecordApp
//
//  Created by se-ryeong on 4/12/24.
//

import UIKit

class MemoListCell: UITableViewCell {
    
    static let identifier = "MemoListCell"
    
    let memoView: MemoView = {
        let view = MemoView()
        view.textView.isEditable = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
        
        selectionStyle = .none
        backgroundColor = .init(resource: .background)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(content: Content) {
        memoView.textView.text = content.memo
        memoView.dateLabel.text = content.createDate?.formatted(style: .fullDateWithDot)
    }
    
    private func setUI() {
        addSubviews([memoView])
    }
    
    private func setLayout() {
        memoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
}

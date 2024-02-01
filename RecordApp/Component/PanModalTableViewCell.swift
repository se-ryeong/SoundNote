//
//  PanModalTableViewCell.swift
//  RecordApp
//
//  Created by se-ryeong on 1/30/24.
//

import UIKit

class PanModalTableViewCell: UITableViewCell {
    static let identifier = "PanModalCell"
    
    let editLabel: UILabel = {
        let label = UILabel()
        label.text = "편집"
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    let cancelLable: UILabel = {
        let label = UILabel()
        label.text = "삭제"
        label.textAlignment = .center
        label.textColor = .red
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        contentView.addSubviews([editLabel, cancelLable])
        
    }
    
    func setLayout() {
        editLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

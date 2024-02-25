//
//  MemoCell.swift
//  RecordApp
//
//  Created by se-ryeong on 1/18/24.
//

import UIKit
import PanModal

protocol MemoCellDelegate: AnyObject {
    func didTapEditButton(in cell: MemoCell, item: Content)
}

class MemoCell: UICollectionViewCell {
    weak var delegate: MemoCellDelegate?
    var contentItem: Content?
    
    static let identifier = "MemoCell"
    
    let memoView: MemoView = {
        let view = MemoView()
        
        return view
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "Edit"), for: .normal)
        button.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
        
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
        addSubviews([memoView, editButton])
        editButton.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
    }
    
    func setLayout() {
        memoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.trailing.equalTo(memoView.snp.trailing).offset(-16)
            $0.top.equalTo(memoView.snp.top).offset(16)
        }
    }
    
    @objc func tapEditButton(_ sender: UIButton) {
//        let panModal = PanModalTableViewController()
//        let view = CalendarViewController()
//        view.presentPanModal(panModal)
//        view.modalPresentationStyle = .fullScreen
        guard let contentItem else { return }
        delegate?.didTapEditButton(in: self, item: contentItem)
    }
}


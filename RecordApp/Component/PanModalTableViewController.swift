//
//  PanModalTableViewController.swift
//  RecordApp
//
//  Created by se-ryeong on 1/29/24.
//

import UIKit
import PanModal

class PanModalTableViewController: UIViewController {
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "아무거나 좀 나와봐"
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .yellow
        view.register(UITableViewCell.self, forCellReuseIdentifier: PanModalTableViewCell.identifier)
        view.isScrollEnabled = true
        view.sectionFooterHeight = .zero
        return view
    }()
    
    var scrollView: UIScrollView {
        tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        setLayout()
        setDelegate()
    }
    
    func setUI() {
        view.addSubviews([tableView])
        tableView.addSubviews([label])
    }
    
    func setLayout() {
        tableView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(-12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//            $0.height.equalTo(100)
        }
        
//        label.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//            $0.top.equalTo(tableView.snp.top).offset(12)
//        }
    }
    
    func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private let items = (0...3).map(String.init)

}

extension PanModalTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PanModalCell", for: indexPath) as? PanModalTableViewCell
        else { return UITableViewCell() }
        
        return cell
    }
}

extension PanModalTableViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        scrollView
    }
    
    var shortFormHeight: PanModalHeight {
//        return .contentHeight(200)
        .contentHeight(UIScreen.main.bounds.height * 0.3)
    }
    
//    var longFormHeight: PanModalHeight {
//        return .maxHeightWithTopInset(0)
//    }
    
}

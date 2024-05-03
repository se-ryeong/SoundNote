//
//  SearchMemoViewController.swift
//  RecordApp
//
//  Created by se-ryeong on 3/2/24.
//

import UIKit

class SearchMemoViewController: UIViewController {
    
    private var contentManager = ContentManager()
    
    private var contentList: [Content] = []
    
    private lazy var searchBar: UISearchController = {
        let searchBar = UISearchController(searchResultsController: nil)
        
        return searchBar
    }()
    
    private var memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "background")
        tableView.register(MemoListCell.self, forCellReuseIdentifier: MemoListCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        setUI()
        setLayout()
        setDelegate()
        
        navigationItem.searchController = searchBar
        searchBar.searchBar.placeholder = "Please enter a search term.".localized
        searchBar.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar.isActive = true
    }
    
    private func setUI() {
        view.addSubviews([memoListTableView])
    }
    
    private func setDelegate() {
        memoListTableView.delegate = self
        memoListTableView.dataSource = self
    }
    
    private func setLayout() {
        memoListTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}

extension SearchMemoViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              text.isNotEmpty else {
            contentList = []
            self.memoListTableView.reloadData()
            return
        }
        
        contentList = contentManager.read(keyword: text)
        
        self.memoListTableView.reloadData()
    }
}

extension SearchMemoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListCell.identifier, for: indexPath) as? MemoListCell
        else { return UITableViewCell() }
        
        let content = contentList[indexPath.row]
        cell.configureCell(content: content)
        
        return cell
    }
}

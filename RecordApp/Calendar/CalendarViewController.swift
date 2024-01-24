//
//  CalendarViewController.swift
//  RecordApp
//
//  Created by se-ryeong on 2023/12/28.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    private var contentManager = ContentManager()
    
    var contentList: [Content] = [] {
        didSet {
            pageControl.numberOfPages = self.contentList.count
        }
    }
    
    private var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        
        calendar.scope = .month
        calendar.appearance.todayColor = UIColor(named: "datePick")
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        
        calendar.appearance.weekdayTextColor = .black
        calendar.placeholderType = .none // 현재 달의 날짜들만 표시되도록 설정
        
        calendar.headerHeight = 0
        
        return calendar
    }()
    
    private var monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Color3")
        label.font = .title2
        label.text = ""
        label.textAlignment = .left
        
        return label
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(MemoCell.self, forCellWithReuseIdentifier: MemoCell.identifier)
        view.contentInset = .init(top: 0, left: 0, bottom: 0, right: 32)
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
                
        return view
    }()
    
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(named: "Color3")
        pageControl.pageIndicatorTintColor = UIColor(named: "Color1")
        pageControl.currentPage = 0
        
        return pageControl
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        setUI()
        setLayout()
        setDelegate()
        calendarView.delegate = self
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // 초기값 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let initialMonth = dateFormatter.string(from: Date())
        monthLabel.text = initialMonth
        
        loadMemo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateItems()
    }
    
    func setUI() {
        view.addSubviews([collectionView, calendarView, monthLabel, pageControl])
    }
    
    func setLayout() {
        collectionView.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(calendarView.snp.bottom).offset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        calendarView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.top.equalTo(monthLabel.snp.bottom).offset(8)
            $0.height.equalTo(300)
        }
        
        monthLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(30)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).inset(-8)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func updateItems() {
        let contents = contentManager.read()
        contentList = contents.prefix(5).map { $0 as Content }
        collectionView.reloadData()
    }
    
    func loadMemo() {
        contentList = contentManager.read()
        pageControl.numberOfPages = contentList.count
        
        collectionView.reloadData()
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // 현재 연도
        let thisYear = Calendar.current.component(.year, from: Date.now)
        
        // 캘린더의 현재 페이지
        let year = Calendar.current.component(.year, from: calendar.currentPage)
        let month = Calendar.current.component(.month, from: calendar.currentPage)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        if thisYear == year {
            // 현재 연도와 캘린더 현재 페이지 연도가 같을 때
            let monthString = dateFormatter.string(from: calendar.currentPage)
            monthLabel.text = monthString
        } else {
            let monthString = dateFormatter.string(from: calendar.currentPage)
            monthLabel.text = monthString
        }
    }
    
    // 선택된 날짜 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor(named: "Color2")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return appearance.titleDefaultColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return appearance.titleDefaultColor
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoCell", for: indexPath) as? MemoCell
        else { return UICollectionViewCell() }
        
        // contentList에서 memo 속성을 추출하여 문자열로 합침
        let memoText = contentList.map { $0.memo ?? "" }.joined(separator: "\n")
        cell.memoView.textView.text = memoText
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        self.pageControl.currentPage = page
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // cell의 너비 설정
        let width = (collectionView.bounds.width) - 32
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    // 섹션 사이의 간격 지정, 열 사이의 간격 지정, 아이템들 좌우 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        32
    }
}

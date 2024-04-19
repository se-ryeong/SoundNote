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
    
    var contentList: [Content] = []
    
    // 해당 달의 전체 데이터를 가져온 배열에서 필터링해서 해당 날의 메모만 보여주면 된다.?
    var selectedDateContent: [Content] = [] {
        didSet {
            pageControl.numberOfPages = self.selectedDateContent.count
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
        setKeyboardNotification()
        
        // 초기값 설정
        monthLabel.text = Date.now.formatted(style: .month)
        
        selectedDateContent = contentManager.read().filter {
            $0.createDate?.formatted(style: .fullDateWithHipen) ?? "" == Date.now.formatted(style: .fullDateWithHipen)
        }
        
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateItemsWithMonth()
        loadMemo()
        updateUI()
//        editButton.isHidden = selectedDateContent.isEmpty
    }
    
    func updateUI() {
        collectionView.reloadData()
        calendarView.reloadData()
    }
    
    func setUI() {
        view.addSubviews([monthLabel, collectionView, calendarView, pageControl])
    }
    
    func setLayout() {
        calendarView.snp.makeConstraints {
//            $0.leading.equalTo(view).offset(32)
//            $0.trailing.equalTo(view)
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.top.equalTo(monthLabel.snp.bottom).offset(8)
            $0.height.equalTo(280)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(view).offset(32)
            $0.trailing.equalTo(view)
            $0.top.equalTo(calendarView.snp.bottom).offset(8)
            $0.bottom.equalTo(pageControl.snp.top).offset(-8)
//            $0.height.equalTo(400)
        }
        
        monthLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(30)
        }
        
        pageControl.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(-8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    private func updateItemsWithMonth() {
        let contents = contentManager.read()
            
        //MARK: - 5개만 가능한거 제한 없애기
        contentList = contents.prefix(5).map { $0 as Content }
        collectionView.reloadData()
    }
    
    func loadMemo() {
        let targetDate = calendarView.currentPage.formatted(style: .yearMonthWithHipen)
        
        contentList = contentManager.read().filter {
            $0.createDate?.formatted(style: .yearMonthWithHipen) ?? ""  == targetDate
        }
        
        collectionView.reloadData()
        calendarView.reloadData()
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        monthLabel.text = calendar.currentPage.formatted(style: .month)
        
        loadMemo()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDateContent = contentList.filter {
            $0.createDate?.formatted(style: .fullDateWithHipen) == date.formatted(style: .fullDateWithHipen)
        }
        
        collectionView.reloadData()
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
    
    // 이벤트 Dot표시 개수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if contentList.contains(where: { 
            $0.createDate?.formatted(style: .fullDateWithHipen) == date.formatted(style: .fullDateWithHipen)
        }) {
            return 1
        } else {
            return 0
        }
    }
    
    // Dot 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.systemBrown]
    }
    
    // Selected Dot 색상
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return [UIColor.systemBrown]
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedDateContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemoCell", for: indexPath) as? MemoCell
        else { return UICollectionViewCell() }
        
        // contentList에서 memo 속성을 추출하여 문자열로 합침
        let item = selectedDateContent[indexPath.row]
        cell.memoView.textView.text = item.memo
        cell.memoView.textView.isEditable = false
        cell.memoView.dateLabel.text = item.createDate?.formatted(style: .monthDayWithDot)
        cell.contentItem = item
        cell.delegate = self
        
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

extension CalendarViewController: MemoCellDelegate {
    func didTapEditButton(in cell: MemoCell, item: Content) {
        let bottomSheetView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            let editVC = EditViewController(content: item)
            editVC.delegate = self
            self?.present(editVC, animated: true)
        }
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) {[weak self] _ in
            self?.selectedDateContent.removeAll(where: { $0.id == item.id })
            self?.contentList.removeAll(where: { $0.id == item.id })
            self?.contentManager.delete(content: item)
            
            self?.collectionView.reloadData()
            self?.calendarView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        bottomSheetView.addAction(edit)
        bottomSheetView.addAction(delete)
        bottomSheetView.addAction(cancel)
        present(bottomSheetView, animated: true)
    }
}

extension CalendarViewController: EditViewControllerDelegate {
    func didFinishEdit() {
        loadMemo()
    }
}

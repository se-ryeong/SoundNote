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
    
    private let memoView: MemoView = {
        let view = MemoView()
        
        return view
    }()
        
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        setUI()
        setLayout()
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
    }
    
    func setUI() {
        view.addSubviews([memoView, calendarView, monthLabel])
    }
    
    func setLayout() {
        memoView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
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
    }
    
    func loadMemo() {
        contentList = contentManager.read()
        
        // contentList에서 memo 속성을 추출하여 문자열로 합침
        let memoText = contentList.map { $0.memo ?? "" }.joined(separator: "\n")
        
        // textView.text에 할당
        self.memoView.textView.text = memoText
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

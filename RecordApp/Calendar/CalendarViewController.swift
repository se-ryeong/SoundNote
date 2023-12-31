//
//  CalendarViewController.swift
//  RecordApp
//
//  Created by se-ryeong on 2023/12/28.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    private var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "Color")
        textView.layer.cornerRadius = 10
        
        return textView
    }()
    
    private var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        
        calendar.scope = .month
        calendar.appearance.todayColor = UIColor(named: "datePick")
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase
        
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.placeholderType = .none // 현재 달의 날짜들만 표시되도록 설정     
        
        // header
//        calendar.appearance.headerDateFormat = "MMM"
//        calendar.appearance.headerTitleColor = UIColor(named: "Color3")
//        calendar.appearance.headerTitleAlignment = .left
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUI() {
        view.addSubviews([textView, calendarView, monthLabel])
    }
    
    func setLayout() {
        textView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.top.equalTo(calendarView.snp.bottom).offset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        calendarView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.top.equalTo(monthLabel.snp.bottom).offset(8)
            $0.height.equalTo(360)
        }
        
        monthLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(30)
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
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
}

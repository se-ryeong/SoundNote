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
        calendar.appearance.headerDateFormat = "MMM"
        calendar.appearance.headerTitleColor = UIColor(named: "Color3")
        calendar.appearance.headerTitleAlignment = .left
        
        return calendar
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "background")
        setUI()
        setLayout()
    }
    
    func setUI() {
        view.addSubviews([textView ,calendarView])
    }
    
    func setLayout() {
        textView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.top.equalTo(calendarView.snp.bottom).offset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        calendarView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(360)
        }
    }
 
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
}

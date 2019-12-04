//
//  MonthViewCell.swift
//  CalendarComponentTest
//
//  Created by Akaash Dev on 14/12/17.
//  Copyright © 2017 Akaash Dev. All rights reserved.
//

import UIKit

public class MonthViewCell: CalendarViewCell {
    
    override public var referenceDate: Date {
        get { return monthView.referenceDate }
    }
    
    override public var eventDays: Set<Int> {
        get { return monthView.eventDays }
        set { monthView.eventDays = newValue }
    }
    
    private lazy var monthView: MonthView = {
        let view = MonthView()
        return view
    }()
    
    override public func setupOnce(configuration: CalendarConfig) {
        if initialized { return }
        super.setupOnce(configuration: configuration)
        monthView.viewConfiguration = configuration
    }
    
    override public func setupCell(calendar: Calendar, referenceDate: Date, selectedDate: Date?, maximumDate: Date?, minimumDate: Date?) {
        super.setupCell(calendar: calendar, referenceDate: referenceDate, selectedDate: selectedDate, maximumDate: maximumDate, minimumDate: minimumDate)
        monthView.referenceDate = referenceDate
        monthView.selectedDate = selectedDate
        monthView.calendar = calendar
    }
    
    override public func setDelegate(_ delegate: CalendarViewCellDelegate) {
        super.setDelegate(delegate)
        guard let monthDelegate = delegate as? MonthViewDelegate else {
            print("Assigning any other type of 'CalendarViewCellDelegate' other than 'MonthViewDelegate' doesn't have any effect on 'MonthViewCell'")
            return
        }
        monthView.delegate = monthDelegate
    }
    
    override public func setupViews() {
        super.setupViews()
        addSubview(monthView)
    }
    
    override public func alignViews() {
        super.alignViews()
        monthView.frame = CGRect(
            x: 0,
            y: weekTitleView.frame.maxY,
            width: bounds.width,
            height: bounds.height - weekTitleView.frame.maxY
        )
    }
    
}

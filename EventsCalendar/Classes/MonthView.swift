//
//  MonthView.swift
//  CalenderView
//
//  Created by Akaash Dev on 13/12/17.
//  Copyright © 2017 Akaash Dev. All rights reserved.
//

import UIKit

public protocol MonthViewDelegate: ClassProtocol, CalendarViewCellDelegate {
    func monthViewDateSelectionChanged(selectedDate: Date, markedDate: Bool)
    func scrollToNextMonthCalendar(withDateSelected: Date)
    func scrollToPrevMonthCalendar(withDateSelected: Date)
}

public class MonthView: UIView {
    
//MARK: Properties
    weak public var delegate: MonthViewDelegate?
    public var calendar = Calendar.current
    
    public var viewConfiguration: CalendarConfig = .default {
        didSet {
            setNeedsDisplay()
        }
    }
    
//MARK: Get-only Properties
    public var monthStartDate: Date {
        guard let startDate = _monthStartDate else {
            let startDate_ = referenceDate.firstDateOfMonth(calendar: calendar)
            _monthStartDate = startDate_
            return startDate_
        }
        return startDate
    }
    
//MARK: Stored Properties
    public var referenceDate: Date {
        get {
            guard let referenceDate = _referenceDate else {
                logError("currentMonthReferenceDate is required to populate MonthView. Possiblity of inconsistent data population.")
                return Date()
            }
            return referenceDate
        }
        set {
            _monthStartDate = newValue.firstDateOfMonth(calendar: calendar)
            _referenceDate = newValue
        }
    }
    
//MARK: Observer Properties
    public var eventDays = Set<Int>() { didSet { refreshDisplay() } }
    public var selectedDate: Date? { didSet { refreshDisplay() } }
    
    private var _referenceDate: Date? { didSet { refreshDisplay() } }
    private var _monthStartDate: Date?
    
//MARK: Private Properties
    private let todayDate = Date()
    
    private let numberOfRows = 6
    
//MARK: Initializers
    override public func draw(_ rect: CGRect) {
        let numOfBlocks = numberOfRows * 7
        
        let cellWidth = Utils.getCellWidth(for: rect, configuration: viewConfiguration)
        let cellHeight = Utils.getMonthCellHeight(for: rect, configuration: viewConfiguration)
        
        let firstWeekDayIndexOfTheMonth = monthStartDate.weekDay(calendar: calendar) - 1
        let numOfDaysInCurrentMonth = monthStartDate.numDaysInMonth(calendar: calendar)
        let numOfDaysInPrevMonth = monthStartDate.offsetDay(-1, calendar: calendar).numDaysInMonth(calendar: calendar)
        
        let selectedDateBlock: Int?
        
        if let selectedDate = selectedDate, selectedDate.isSameAsMonth(date: monthStartDate, calendar: calendar) {
            selectedDateBlock = (selectedDate.day(calendar: calendar) - 1) + firstWeekDayIndexOfTheMonth
        } else {
            selectedDateBlock = nil
        }
        
        let pointSize = viewConfiguration.dateLabelFont.pointSize
        
        viewConfiguration.backgroundColor.setFill()
        UIRectFill(rect)
        
        for blockNum in 0 ..< numOfBlocks {
            
            let columnNum = CGFloat(blockNum % 7)
            let rowNum = CGFloat(blockNum / 7)
            
            let originX = columnNum * cellWidth
            let originY = rowNum * cellHeight
            
            var blockDayNumber = 0
            var isOtherMonthDate = false
            
            if blockNum < firstWeekDayIndexOfTheMonth {
                isOtherMonthDate = true
                blockDayNumber = (numOfDaysInPrevMonth - firstWeekDayIndexOfTheMonth) + (blockNum + 1)
            } else if blockNum >= (firstWeekDayIndexOfTheMonth + numOfDaysInCurrentMonth) {
                isOtherMonthDate = true
                blockDayNumber = (blockNum + 1) - (firstWeekDayIndexOfTheMonth + numOfDaysInCurrentMonth)
            } else {
                blockDayNumber = (blockNum - firstWeekDayIndexOfTheMonth) + 1
            }
            
            var isToday = false
            var isLessThanToday = false
            var isSelectedDate = false
            
            if todayDate.day(calendar: calendar) == blockDayNumber && todayDate.isSameAsMonth(date: monthStartDate, calendar: calendar) && todayDate.isSameAsYear(date: monthStartDate, calendar: calendar) {
                isToday = true
            }
            
            if blockDayNumber < todayDate.day(calendar: calendar) && todayDate.isSameAsMonth(date: monthStartDate, calendar: calendar) && todayDate.isSameAsYear(date: monthStartDate, calendar: calendar) {
                isLessThanToday = true
            }
            
            if  blockNum == selectedDateBlock {
                if !isOtherMonthDate && selectedDate?.isSameAsMonth(date: monthStartDate, calendar: calendar) ?? false {
                    
                    isSelectedDate = true
                    let minDimension = min(cellWidth, cellHeight)
                    let diameter =  0.92 * minDimension
                    let rectangleGrid = CGRect(
                        x: originX + ((cellWidth - diameter) / 2),
                        y: originY + ((cellHeight - diameter) / 2) + 2,
                        width: diameter,
                        height: diameter
                    )
                    let path = UIBezierPath(
                        roundedRect: rectangleGrid,
                        cornerRadius: diameter / 2
                    )
                    
                    viewConfiguration.selectionColor.setFill()
                    path.fill()
                }
            }
            
            if !isOtherMonthDate && eventDays.contains(blockDayNumber) {
                let minDimension = min(cellWidth, cellHeight)
                let diameter =  0.15 * minDimension
                let labelHeight = viewConfiguration.dateLabelFont.pointSize
                let padding = 0.16 * minDimension
                let rectangleGrid = CGRect(
                    x: originX + ((cellWidth - diameter) / 2),
                    y: originY + ((cellHeight - diameter) / 2) + (labelHeight / 2) + padding,
                    width: diameter,
                    height: diameter
                )
                let path = UIBezierPath(
                    roundedRect: rectangleGrid,
                    cornerRadius: diameter / 2
                )
                
                if isSelectedDate {
                    viewConfiguration.selectedDotColor.setFill()
                } else if isOtherMonthDate {
                    viewConfiguration.otherMonthLabelColor.setFill()
                } else {
                    viewConfiguration.dotColor.setFill()
                }
                path.fill()
            }
            
            let numberXPos = originX
            let numberYPos = originY + (cellHeight - pointSize) / 2
            let dateStr = "\(blockDayNumber)"
            
            let isValidDate = !(viewConfiguration.invalidatePastDates && (isOtherMonthDate || isLessThanToday))
            
            func isWeekend(_ blockNum: Int) -> Bool {
                if blockNum % Constant.numberOfDaysInWeek == 0 {
                    return true
                }
                if viewConfiguration.shouldConsiderSaturdayAsWeekend {
                    return (blockNum + 1) % Constant.numberOfDaysInWeek == 0
                }
                return false
            }
            
            let textColor: UIColor
            if isOtherMonthDate {
                textColor = viewConfiguration.otherMonthLabelColor
            } else if !isValidDate {
                textColor = viewConfiguration.invalidLabelColor
            } else if isSelectedDate {
                textColor = viewConfiguration.selectedLabelColor
            } else if isToday {
                textColor = viewConfiguration.todayLabelColor
            } else if isWeekend(blockNum) {
                textColor = viewConfiguration.weekendLabelColor
            } else {
                textColor = viewConfiguration.validLabelColor
            }
            
            let font = viewConfiguration.dateLabelFont
            
            let labelRect = CGRect(x: numberXPos, y: numberYPos, width: cellWidth, height: cellHeight)
            dateStr.draw(in: labelRect, with: font, lineBreakMode: NSLineBreakMode.byClipping, alignment: .center, with: textColor)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let cellWidth =  Utils.getCellWidth(for: bounds, configuration: viewConfiguration)
        let cellHeight = Utils.getMonthCellHeight(for: bounds, configuration: viewConfiguration)
        let location: CGPoint = touch.location(in: self)
        
        if location.y > 0 {
            let column: Int = Int(location.x / cellWidth)
            let row: Int = Int(location.y / cellHeight)
            let blockNum: Int = column + (row * 7)
            let firstWeekDayIndexOfTheMonth = self.monthStartDate.weekDay(calendar: calendar) - 1
            let dateLabel = (blockNum + 1) - firstWeekDayIndexOfTheMonth
            selectDate(dateLabel)
        }
    }
    
//MARK: Methods
    private func selectDate(_ dateLabel: Int) {
        var comps = calendar.dateComponents([.year, .month, .day, .hour, .timeZone], from: referenceDate)
        comps.day = dateLabel
        guard let newSelectedDate = calendar.date(from: comps) else { return }
        
        if viewConfiguration.invalidatePastDates,
            newSelectedDate.lessThan(date: todayDate)
        { return }
        
        if newSelectedDate.inBeforeMonths(from: referenceDate) {
            delegate?.scrollToPrevMonthCalendar(withDateSelected: newSelectedDate)
        } else if newSelectedDate.inAfterMonths(from: referenceDate) {
            delegate?.scrollToNextMonthCalendar(withDateSelected: newSelectedDate)
        } else {
            if newSelectedDate == selectedDate { return }
            delegate?.monthViewDateSelectionChanged(selectedDate: newSelectedDate, markedDate: eventDays.contains(dateLabel))
        }
        
    }
    
    private func refreshDisplay() {
        setNeedsDisplay()
        layer.displayIfNeeded()
    }
    
}

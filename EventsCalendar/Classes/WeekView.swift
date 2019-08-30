//
//  WeekView.swift
//  CalenderView
//
//  Created by Akaash Dev on 12/12/17.
//  Copyright © 2017 Akaash Dev. All rights reserved.
//

import UIKit

public protocol WeekViewDelegate: ClassProtocol, CalendarViewCellDelegate {
    func weekView(_ weekView: WeekView, selectionDataDidChangeTo date: Date)
}

public class WeekView: UIView {
    
//MARK: Properties
    weak public var delegate: WeekViewDelegate?
    public var calendar = Calendar.current
    public var selectedDate: Date?
    
    public var maximumDate: Date?
    
    public var eventDays = Set<Int>() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var viewConfiguration: CalendarConfig = .default {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
//MARK: Get-only Properties
    public var startDate: Date {
        if let date = _startDate {
            return date
        }
        _startDate = referenceDate.firstDateOfWeek(calendar: calendar)
        return _startDate!
    }
    
//MARK: Stores Properties
    public var referenceDate: Date {
        get {
            guard let referenceDate = _referenceDate else {
                logError("currentWeekReferenceDate is required to populate WeekView. Possiblity of inconsistent data population.")
                return Date()
            }
            return referenceDate
        }
        set {
            _startDate = newValue.firstDateOfWeek(calendar: calendar)
            _referenceDate = newValue
        }
    }
    
//MARK: Observer Properties
    private var _startDate: Date?
    private var _referenceDate: Date? {
        didSet {
            setNeedsDisplay()
        }
    }
    
//MARK: Private Properties
    private let todayDate = Date()
    
//MARK: Initializers
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        viewConfiguration.backgroundColor.setFill()
        UIRectFill(rect)
        
        let cellWidth = Utils.getCellWidth(for: rect, configuration: viewConfiguration)
        let cellHeight = Utils.getWeekCellHeight(for: rect, configuration: viewConfiguration)
        
        let pointSize = viewConfiguration.dateLabelFont.pointSize
        
        for blockNum in 0 ..< Constant.numberOfDaysInWeek {
            
            let blockDate = startDate.offsetDay(blockNum, calendar: calendar)
            
            let originX = CGFloat(blockNum) * cellWidth
            let originY = CGFloat(0)
            
            let center = CGPoint(
                x: originX + (cellWidth/2),
                y: originY + (cellHeight/2)
            )
            
            var isSelectedDate = false
            if let date = selectedDate {
                isSelectedDate = date.equals(date: blockDate)
            }
            
            let isToday = todayDate.equals(date: blockDate)
            
            var isValidDate: Bool
            if viewConfiguration.invalidatePastDates {
                isValidDate = !blockDate.lessThan(date: todayDate)
            } else {
                isValidDate = true
            }
            
            if isValidDate, let maxDate = maximumDate {
                isValidDate = !blockDate.greaterThanOrEqualTo(date: maxDate)
            }
            
            if isSelectedDate {
                let side = min(cellWidth, cellHeight) - 8
                let selectionRect = CGRect(
                    x: center.x - (side/2) + 2,
                    y: center.y - (side/2) + 6,
                    width: side - 3,
                    height: side - 3
                )
                let path = UIBezierPath(
                    roundedRect: selectionRect,
                    cornerRadius: side/2
                )
                viewConfiguration.selectionColor.setFill()
                path.fill()
            }
            
            if eventDays.contains(blockDate.day(calendar: calendar)) {
                let dotDiameter: CGFloat = 5
                let dotOriginX = originX + (cellWidth / 2) - (dotDiameter/2)
                let dotOriginY = originY + (cellHeight - CGFloat(11))
            
                let dotRect = CGRect(x: dotOriginX, y: dotOriginY, width: dotDiameter, height: dotDiameter)
                let path = UIBezierPath(roundedRect: dotRect, cornerRadius: dotDiameter/2)
            
                isSelectedDate ? UIColor.white.setFill() : viewConfiguration.dotColor.setFill()
                path.fill()
            }
            
            let numberXPos = originX
            let numberYPos = originY + (cellHeight - pointSize) / 2
            let dateStr = "\(blockDate.day(calendar: calendar))"
            
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
            if !isValidDate {
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
            let labelRect = CGRect(x: numberXPos, y: numberYPos + 2, width: cellWidth, height: cellHeight)
            dateStr.draw(
                in: labelRect,
                with: font,
                lineBreakMode: .byClipping,
                alignment: .center,
                with: textColor
            )
            
        }
        
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if bounds.contains(location) {
            let cellWidth = frame.width / 7
            let column = Int(location.x / cellWidth)
            selectDate(startDate.offsetDay(column, calendar: calendar))
        }
    }
    
//MARK: Methods
    private func selectDate(_ date: Date) {
        if viewConfiguration.invalidatePastDates,
            date.lessThan(date: todayDate)
        { return }
        
        if let maxDate = maximumDate,
            date.greaterThanOrEqualTo(date: maxDate)
        { return }
        
        delegate?.weekView(self, selectionDataDidChangeTo: date)
    }
    
}


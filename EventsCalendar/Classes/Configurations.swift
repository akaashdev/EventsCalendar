//
//  Configurations.swift
//  CalendarComponentTest
//
//  Created by Akaash Dev on 29/04/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit

public enum MonthTitleStyle {
    case full, short, veryShort
    
    var symbols: [String] {
        switch self {
        case .full: return Calendar.current.monthSymbols
        case .short: return Calendar.current.shortMonthSymbols
        case .veryShort: return Calendar.current.veryShortMonthSymbols
        }
    }
}


struct Constant {
    static let numberOfDaysInWeek = 7
    static let numberOfMaximumWeeks = 6
}


public protocol CellDimensionConfig {
    var cellMaxWidth: CGFloat? { get }
    var cellMaxHeight: CGFloat? { get }
}

public protocol WeekTitleViewConfig: CellDimensionConfig {
    var weekdayTitleFont: UIFont { get }
    var weekdayTitleColor: UIColor { get }
    var weekdayTitleHeight: CGFloat { get }
    var weekdayTitles: [String] { get }
    var weekdayTitlesBackgroundColor: UIColor { get }
}

public protocol MonthTitleViewConfig {
    var monthTitleFont: UIFont { get }
    var monthTitleHeight: CGFloat { get }
    var monthTitleTextColor: UIColor { get }
    var monthTitleAlignment: NSTextAlignment { get }
    var monthTitleBackgroundColor: UIColor { get }
    var monthTitleStyle: MonthTitleStyle { get }
    var monthTitleIncludesYear: Bool { get }
}

public protocol CalendarViewConfig: CellDimensionConfig {
    var selectionColor: UIColor { get }
    var dotColor: UIColor { get }
    var selectedDotColor: UIColor { get }
    
    var weekendLabelColor: UIColor { get }
    var validLabelColor: UIColor { get }
    var invalidLabelColor: UIColor { get }
    var selectedLabelColor: UIColor { get }
    var todayLabelColor: UIColor { get }
    var otherMonthLabelColor: UIColor { get }
    
    var dateLabelFont: UIFont { get }
    
    var invalidatePastDates: Bool { get }
    var shouldConsiderSaturdayAsWeekend: Bool { get }
    
    var monthTitleFont: UIFont { get }
}


public struct CalendarConfig: CalendarViewConfig, WeekTitleViewConfig, MonthTitleViewConfig {
    
    public static let `default`: CalendarConfig = CalendarConfig()
    
    public var backgroundColor: UIColor
    
    public var selectionColor: UIColor
    public var dotColor: UIColor
    public var selectedDotColor: UIColor
    
    public var weekendLabelColor: UIColor
    public var validLabelColor: UIColor
    public var invalidLabelColor: UIColor
    public var selectedLabelColor: UIColor
    public var todayLabelColor: UIColor
    public var otherMonthLabelColor: UIColor
    
    public var dateLabelFont: UIFont
    
    public var cellMaxWidth: CGFloat?
    public var cellMaxHeight: CGFloat?
    
    public var invalidatePastDates: Bool
    public var shouldConsiderSaturdayAsWeekend: Bool
    
    public var monthTitleFont: UIFont
    public var monthTitleHeight: CGFloat
    public var monthTitleTextColor: UIColor
    public var monthTitleAlignment: NSTextAlignment
    public var monthTitleBackgroundColor: UIColor
    public var monthTitleStyle: MonthTitleStyle
    public var monthTitleIncludesYear: Bool
    
    public var weekdayTitles: [String]
    public var weekdayTitleFont: UIFont
    public var weekdayTitleColor: UIColor
    public var weekdayTitleHeight: CGFloat
    public var weekdayTitlesBackgroundColor: UIColor
    
    public init(
        backgroundColor: UIColor = .white,
        selectionColor: UIColor = .blue,
        dotColor: UIColor = .blue,
        selectedDotColor: UIColor = .blue,
        weekendLabelColor: UIColor = .darkGray,
        validLabelColor: UIColor = .black,
        invalidLabelColor: UIColor = .lightGray,
        selectedLabelColor: UIColor = .white,
        todayLabelColor: UIColor = .blue,
        otherMonthLabelColor: UIColor = .lightGray,
        dateLabelFont: UIFont = UIFont.systemFont(ofSize: 14),
        cellMaxWidth: CGFloat? = nil,
        cellMaxHeight: CGFloat? = nil,
        invalidatePastDates: Bool = false,
        shouldConsiderSaturdayAsWeekend: Bool = true,
        monthTitleFont: UIFont = UIFont.systemFont(ofSize: 30, weight: .heavy),
        monthTitleHeight: CGFloat = 34,
        monthTitleTextColor: UIColor = .black,
        monthTitleAlignment: NSTextAlignment = .natural,
        monthTitleBackgroundColor: UIColor = .white,
        monthTitleStyle: MonthTitleStyle = .full,
        monthTitleIncludesYear: Bool = true,
        weekdayTitles: [String] = Calendar.current.veryShortWeekdaySymbols,
        weekdayTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
        weekdayTitleColor: UIColor = .blue,
        weekdayTitleHeight: CGFloat = 24,
        weekdayTitleBackgroundColor: UIColor = .white
    ) {
        self.backgroundColor = backgroundColor
        
        self.selectionColor = selectionColor
        self.dotColor = dotColor
        self.selectedDotColor = selectedDotColor
        
        self.weekendLabelColor = weekendLabelColor
        self.validLabelColor = validLabelColor
        self.invalidLabelColor = invalidLabelColor
        self.selectedLabelColor = selectedLabelColor
        self.todayLabelColor = todayLabelColor
        self.otherMonthLabelColor = otherMonthLabelColor
        
        self.dateLabelFont = dateLabelFont
        
        self.cellMaxWidth = cellMaxWidth
        self.cellMaxHeight = cellMaxHeight
        
        self.invalidatePastDates = invalidatePastDates
        self.shouldConsiderSaturdayAsWeekend = shouldConsiderSaturdayAsWeekend
        
        self.monthTitleFont = monthTitleFont
        self.monthTitleHeight = monthTitleHeight
        self.monthTitleAlignment = monthTitleAlignment
        self.monthTitleTextColor = monthTitleTextColor
        self.monthTitleBackgroundColor = monthTitleBackgroundColor
        self.monthTitleStyle = monthTitleStyle
        self.monthTitleIncludesYear = monthTitleIncludesYear
        
        self.weekdayTitles = weekdayTitles
        self.weekdayTitleFont = weekdayTitleFont
        self.weekdayTitleColor = weekdayTitleColor
        self.weekdayTitleHeight = weekdayTitleHeight
        self.weekdayTitlesBackgroundColor = weekdayTitleBackgroundColor
    }
    
    public init(configure: (inout CalendarConfig)->()) {
        self.init()
        configure(&self)
    }
    
}


class Utils {
    
    class func getCellWidth(for rect: CGRect, configuration: CellDimensionConfig) -> CGFloat {
        let calculatedWidth = rect.width / CGFloat(Constant.numberOfDaysInWeek)
        if let maxWidth = configuration.cellMaxWidth {
            return min(maxWidth, calculatedWidth)
        }
        return calculatedWidth
    }
    
    class func getMonthCellHeight(for rect: CGRect, configuration: CellDimensionConfig) -> CGFloat {
        let calculatedHeight = rect.height / CGFloat(Constant.numberOfMaximumWeeks)
        if let maxHeight = configuration.cellMaxHeight {
            return min(maxHeight, calculatedHeight)
        }
        return calculatedHeight
    }
    
    class func getWeekCellHeight(for rect: CGRect, configuration: CellDimensionConfig) -> CGFloat {
        let calculatedHeight = rect.height
        if let maxHeight = configuration.cellMaxHeight {
            return min(maxHeight, calculatedHeight)
        }
        return calculatedHeight
    }
    
}

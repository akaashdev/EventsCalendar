//
//  WeekViewCell.swift
//  CalendarComponentTest
//
//  Created by Akaash Dev on 14/12/17.
//  Copyright © 2017 Akaash Dev. All rights reserved.
//

import UIKit

public protocol CalendarViewCellDelegate {
    
}

public protocol CalendarViewCellProtocol: ClassProtocol where Self: UICollectionViewCell {
    var referenceDate: Date { get }
    var pageId: CalendarView.PageID? { get set }
    var eventDays: Set<Int> { get set }
    func setupOnce(configuration: CalendarConfig)
    func setupCell(calendar: Calendar, referenceDate: Date, selectedDate: Date?, maximumDate: Date?, minimumDate: Date?)
    func setDelegate(_ delegate: CalendarViewCellDelegate)
}

public class InfiniteCollectionViewCell: UICollectionViewCell {
    
    var _currentCellIndex: Int = 0
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public class CalendarViewCell: InfiniteCollectionViewCell, CalendarViewCellProtocol {
    
    // Should be overridden
    public var referenceDate: Date { return Date() }
    public var eventDays: Set<Int> = []
    
    public var pageId: CalendarView.PageID? = nil
    
    private (set) public var initialized: Bool = false
    
    private (set) public lazy var weekTitleView: WeekTitleView = {
        let view = WeekTitleView()
        return view
    }()
    
    private (set) public lazy var monthTitleLabel: MonthTitleLabel = {
        let view = MonthTitleLabel()
        view.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        view.backgroundColor = .white
        view.textAlignment = .left
        return view
    }()
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        alignViews()
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        eventDays = []
    }
    
    
    public func setupOnce(configuration: CalendarConfig) {
        if initialized { return }
        
        monthTitleViewHeight = configuration.monthTitleHeight
        weekTitleViewHeight = configuration.weekdayTitleHeight
        
        alignViews()
        weekTitleView.viewConfiguration = configuration
        monthTitleLabel.viewConfiguration = configuration
        initialized = true
    }
    
    public func setupCell(calendar: Calendar, referenceDate: Date, selectedDate: Date?, maximumDate: Date?, minimumDate: Date?) {
        monthTitleLabel.setMonth(
            referenceDate.month(calendar: calendar),
            year: referenceDate.year(calendar: calendar)
        )
    }
    
    public func setDelegate(_ delegate: CalendarViewCellDelegate) {
        
    }

    
    public func setupViews() {
        addSubview(monthTitleLabel)
        addSubview(weekTitleView)
    }
    
    private var monthTitleViewHeight: CGFloat = 34
    private var weekTitleViewHeight: CGFloat = 34
    public func alignViews() {
        monthTitleLabel.frame = CGRect(
            x: 5,
            y: 0,
            width: bounds.width - 10,
            height: monthTitleViewHeight
        )
        weekTitleView.frame = CGRect(
            x: 0,
            y: monthTitleLabel.frame.maxY + 10,
            width: bounds.width,
            height: weekTitleViewHeight
        )
    }
}



public class WeekViewCell: CalendarViewCell {
    
    override public var referenceDate: Date {
        get { return weekView.referenceDate }
    }
    
    override public var eventDays: Set<Int> {
        get { return weekView.eventDays }
        set { weekView.eventDays = newValue }
    }
    
    private lazy var weekView: WeekView = {
        let view = WeekView()
        return view
    }()
    
    override public func setupOnce(configuration: CalendarConfig) {
        if initialized { return }
        super.setupOnce(configuration: configuration)
        weekView.viewConfiguration = configuration
    }
    
    override public func setupCell(calendar: Calendar, referenceDate: Date, selectedDate: Date?, maximumDate: Date?, minimumDate: Date?) {
        super.setupCell(calendar: calendar, referenceDate: referenceDate, selectedDate: selectedDate, maximumDate: maximumDate, minimumDate: minimumDate)
        weekView.referenceDate = referenceDate
        weekView.selectedDate = selectedDate
        weekView.maximumDate = maximumDate
        weekView.calendar = calendar
    }
    
    override public func setDelegate(_ delegate: CalendarViewCellDelegate) {
        super.setDelegate(delegate)
        guard let weekDelegate = delegate as? WeekViewDelegate else {
            print("Assigning any other type of 'CalendarViewCellDelegate' other than 'WeekViewDelegate' doesn't have any effect on 'WeekViewCell'")
            return
        }
        weekView.delegate = weekDelegate
    }
    
    override public func setupViews() {
        super.setupViews()
        addSubview(weekView)
    }
    
    override public func alignViews() {
        super.alignViews()
        weekView.frame = CGRect(
            x: 0,
            y: weekTitleView.frame.maxY,
            width: bounds.width,
            height: bounds.height - weekTitleView.frame.maxY
        )
    }
    
}

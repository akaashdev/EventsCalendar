//
//  CalendarView.swift
//  CalendarComponentTest
//
//  Created by Akaash Dev on 21/05/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit


public protocol ClassProtocol: class {  }

public protocol CalendarProtocol: ClassProtocol {
    var delegate: CalendarViewDelegate? { get set }
    var collectionView: UICollectionView { get }
    
    var viewConfiguration: CalendarConfig { get set }
    var allowsDateSelection: Bool { get set }
    var allowsEventsCaching: Bool { get set }
    
    var itemSize: Size { get set }
    var scrollDirection: UICollectionView.ScrollDirection { get set }
    var isPagingEnabled: Bool { get set }
    
    var selectedDate: Date? { get set }
    
    var startDate: Date { get }
    var endDate: Date { get }
    var calendarType: CalendarViewType { get }
    var numberOfPages: Int { get }
    
    func refreshLayout()
    func scroll(to date: Date, animated: Bool)
    func getIndexPath(of date: Date) -> IndexPath
}

public protocol CalendarViewDelegate: ClassProtocol {
    func calendarView(_ calendarView: CalendarProtocol, didChangeSelectionDateTo date: Date, at indexPath: IndexPath)
    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date) -> Set<Int>?
    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date, completion: @escaping (Result<Set<Int>, Error>)->())
}

public extension CalendarViewDelegate {
    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date) -> Set<Int>? {
        return nil
    }
    
    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date, completion: @escaping (Result<Set<Int>, Error>)->()) {
        completion(.success([]))
        return
    }
}

public struct CalendarInfo {
    public let month: Int
    public let year: Int
    public let startDay: Int
    public let endDay: Int
    public let startDate: Date
    public let endDate: Date
}

public enum CalendarViewType {
    case month, week
}


public class CalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CalendarProtocol {
    
    weak public var delegate: CalendarViewDelegate?
    
    public var viewConfiguration: CalendarConfig = .default
    public var allowsDateSelection: Bool = true
    public var allowsEventsCaching: Bool = true
    
    public var itemSize: Size = .identity {
        didSet {
            _itemSize = itemSize.getTransformed(size: bounds.size)
            collectionView.reloadData()
        }
    }
    
    public var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            flowLayout.scrollDirection = scrollDirection
            collectionView.reloadData()
        }
    }
    
    public var isPagingEnabled: Bool {
        get {
            return collectionView.isPagingEnabled
        }
        set {
            collectionView.isPagingEnabled = newValue
        }
    }
    
    public var selectedDate: Date? {
        get {
            return allowsDateSelection ? _selectedDate : nil
        }
        set {
            let oldValue = _selectedDate
            _selectedDate = newValue
            refreshIfNeeded(old: oldValue, new: newValue)
        }
    }
    
    public let startDate: Date
    public let endDate: Date
    public let calendarType: CalendarViewType
    public let numberOfPages: Int
    
    public typealias Events = Set<Int>
    public typealias PageID = String
    
    private var _itemSize: CGSize = .zero
    private var _selectedDate: Date?
    
    private let kMonthCellId = "monthCell"
    private let kWeekCellId = "weekCell"
    
    
    public init(frame: CGRect = .zero, type: CalendarViewType, startDate: Date, endDate: Date, numberOfPages: Int) {
        self.startDate = startDate
        self.endDate = endDate
        self.numberOfPages = numberOfPages
        self.calendarType = type
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        _itemSize = itemSize.getTransformed(size: bounds.size)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPages
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let calendar = Calendar.current
        let cell: CalendarViewCellProtocol
        let referenceDate: Date
        let startDate: Date
        let endDate: Date
        
        func manageEventsPopulation(in cell: CalendarViewCellProtocol) {
            guard let delegate = delegate else { return }
            
            let info = CalendarInfo(
                month: referenceDate.month(calendar: calendar),
                year: referenceDate.year(calendar: calendar),
                startDay: startDate.day(calendar: calendar),
                endDay: endDate.day(calendar: calendar),
                startDate: startDate,
                endDate: endDate
            )
            
            let pageId = getPageId(from: info)
            cell.pageId = pageId
            
            if let days = getCachedEvents(for: pageId) {
                cell.eventDays = days
            }
            
            else if let days = delegate.calendarView(self, eventDaysForCalendar: calendarType, with: info, and: referenceDate) {
                cell.eventDays = days
            }
                
            else {
                delegate.calendarView(self, eventDaysForCalendar: calendarType, with: info, and: referenceDate) { [weak cell] result in
                    switch result {
                    case .failure(_): break
                    case .success(let days):
                        self.cacheEvents(days, for: pageId)
                        if cell?.pageId == pageId {
                            cell?.eventDays = days
                        }
                    }
                }
            }
        }
        
        switch calendarType {
        case .month:
            let monthCell = collectionView.dequeueReusableCell(withReuseIdentifier: kMonthCellId, for: indexPath) as! MonthViewCell
            setupMonthCell(monthCell, at: indexPath)
            referenceDate = self.startDate.offsetMonth(indexPath.item, calendar: calendar)
            startDate = referenceDate.firstDateOfMonth(calendar: calendar)
            endDate = referenceDate.endDateOfMonth(calendar: calendar)
            cell = monthCell
            
        case .week:
            let weekCell = collectionView.dequeueReusableCell(withReuseIdentifier: kWeekCellId, for: indexPath) as! WeekViewCell
            setupWeekCell(weekCell, at: indexPath)
            referenceDate = self.startDate.offsetDay(indexPath.item * Constant.numberOfDaysInWeek, calendar: calendar)
            startDate = referenceDate.firstDateOfWeek(calendar: calendar)
            endDate = startDate.offsetDay(Constant.numberOfDaysInWeek, calendar: calendar)
            cell = weekCell
        }
        
        
        cell.setupOnce(configuration: viewConfiguration)
        cell.setupCell(
            calendar: calendar,
            referenceDate: referenceDate,
            selectedDate: selectedDate,
            maximumDate: self.endDate,
            minimumDate: self.startDate
        )
        manageEventsPopulation(in: cell)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return _itemSize
    }
    
    
    public func setupMonthCell(_ cell: MonthViewCell, at indexPath: IndexPath) {
        
    }
    
    public func setupWeekCell(_ cell: WeekViewCell, at indexPath: IndexPath) {
        
    }
    
    public func refreshLayout() {
        let visibleIndexPath = collectionView.indexPathsForVisibleItems.first
        collectionView.reloadData()
        if let indexPath = visibleIndexPath {
            collectionView.scrollToItem(
                at: indexPath,
                at: scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically,
                animated: false
            )
        }
    }
    
    
    public func scroll(to date: Date, animated: Bool = true) {
        collectionView.scrollToItem(
            at: getIndexPath(of: date),
            at: scrollDirection == .horizontal ? .centeredHorizontally : .centeredVertically,
            animated: animated
        )
    }
    
    public func getIndexPath(of date: Date) -> IndexPath {
        let offset: Int
        switch calendarType {
        case .month:
            let monthStartDate = startDate.firstDateOfMonth(calendar: Calendar.current)
            offset = date.months(from: monthStartDate)
        case .week:
            let weekStartDate = startDate.firstDateOfWeek(calendar: Calendar.current)
            offset = date.weeks(from: weekStartDate)
        }
        return IndexPath(item: offset, section: 0)
    }
    
    
    private var eventsCache: [PageID: Events] = [:]
    
    private func getPageId(from info: CalendarInfo) -> PageID {
        return "\(info.startDay)-\(info.endDay)_\(info.month)_\(info.year)"
    }
    
    private func getCachedEvents(for id: PageID) -> Events? {
        guard allowsEventsCaching else { return nil }
        return eventsCache[id]
    }
    
    private func cacheEvents(_ events: Events, for id: PageID) {
        guard allowsEventsCaching else { return }
        eventsCache[id] = events
    }
    
    private func clearCache() {
        eventsCache.removeAll()
    }
    
    
    private func refreshIfNeeded(old: Date?, new: Date?) {
        if old == new {
            // Same date reselect case
            return
        }
        
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        }
    }
    
    private (set) public lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.register(MonthViewCell.self, forCellWithReuseIdentifier: kMonthCellId)
        view.register(WeekViewCell.self, forCellWithReuseIdentifier: kWeekCellId)
        view.dataSource = self
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
}


public class MonthCalendarView: CalendarView, MonthViewDelegate {
    
    public let numberOfMonths: Int
    
    
    public convenience init(frame: CGRect = .zero, startDate: Date, endDate: Date) {
        self.init(
            frame: frame,
            startDate: startDate,
            numberOfMonths: endDate.months(from: startDate)
        )
    }
    
    public init(frame: CGRect = .zero, startDate: Date, numberOfMonths: Int) {
        self.numberOfMonths = numberOfMonths
        super.init(
            frame: frame,
            type: .month,
            startDate: startDate,
            endDate: startDate.offsetMonth(numberOfMonths, calendar: Calendar.current),
            numberOfPages: numberOfMonths
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func setupMonthCell(_ cell: MonthViewCell, at indexPath: IndexPath) {
        super.setupMonthCell(cell, at: indexPath)
        cell.setDelegate(self)
    }
    
    
    public func monthViewDateSelectionChanged(selectedDate: Date, markedDate: Bool) {
        self.selectedDate = selectedDate
        delegate?.calendarView(self, didChangeSelectionDateTo: selectedDate, at: getIndexPath(of: selectedDate))
    }
    
    
    public func scrollToNextMonthCalendar(withDateSelected: Date) {
        let visibleItems = collectionView.indexPathsForVisibleItems
        if visibleItems.count > 1 {
            logError("One or more month cell visible. MonthCalendar may not behave the way as expected.")
        }
        
        guard let indexPath = visibleItems.first,
            indexPath.item < numberOfMonths - 1
            else { return }
        collectionView.scrollToItem(
            at: IndexPath(item: indexPath.item + 1, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        
        if allowsDateSelection {
            self.selectedDate = withDateSelected
        }
    }
    
    public func scrollToPrevMonthCalendar(withDateSelected: Date) {
        let visibleItems = collectionView.indexPathsForVisibleItems
        if visibleItems.count > 1 {
            logError("One or more month cell visible. MonthCalendar may not behave the way as expected.")
        }
        
        guard let indexPath = visibleItems.first,
            indexPath.item > 0
            else { return }
        collectionView.scrollToItem(
            at: IndexPath(item: indexPath.item - 1, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        
        if allowsDateSelection {
            self.selectedDate = withDateSelected
        }
    }
    
}


public class WeekCalendarView: CalendarView, WeekViewDelegate {
    
    public let numberOfWeeks: Int
    
    
    public convenience init(frame: CGRect = .zero, startDate: Date, endDate: Date) {
        self.init(
            frame: frame,
            startDate: startDate,
            numberOfWeeks: endDate.weeks(from: startDate)
        )
    }
    
    public init(frame: CGRect = .zero, startDate: Date, numberOfWeeks: Int) {
        self.numberOfWeeks = numberOfWeeks
        super.init(
            frame: frame,
            type: .week,
            startDate: startDate,
            endDate: startDate.offsetDay(numberOfWeeks * Constant.numberOfDaysInWeek, calendar: Calendar.current),
            numberOfPages: numberOfWeeks
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func setupWeekCell(_ cell: WeekViewCell, at indexPath: IndexPath) {
        super.setupWeekCell(cell, at: indexPath)
        cell.setDelegate(self)
    }
    
    public func weekView(_ weekView: WeekView, selectionDataDidChangeTo date: Date) {
        self.selectedDate = date
        delegate?.calendarView(self, didChangeSelectionDateTo: date, at: getIndexPath(of: date))
    }
    
    
    public func scrollToNextMonthCalendar(withDateSelected: Date) {
        let visibleItems = collectionView.indexPathsForVisibleItems
        if visibleItems.count > 1 {
            logError("One or more month cell visible. MonthCalendar may not behave the way as expected.")
        }
        
        guard let indexPath = visibleItems.first,
            indexPath.item < numberOfWeeks - 1
        else { return }
        collectionView.scrollToItem(
            at: IndexPath(item: indexPath.item + 1, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        
        if allowsDateSelection {
            self.selectedDate = withDateSelected
        }
    }
    
    public func scrollToPrevMonthCalendar(withDateSelected: Date) {
        let visibleItems = collectionView.indexPathsForVisibleItems
        if visibleItems.count > 1 {
            logError("One or more month cell visible. MonthCalendar may not behave the way as expected.")
        }
        
        guard let indexPath = visibleItems.first,
            indexPath.item > 0
        else { return }
        collectionView.scrollToItem(
            at: IndexPath(item: indexPath.item - 1, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        
        if allowsDateSelection {
            self.selectedDate = withDateSelected
        }
    }
    
}

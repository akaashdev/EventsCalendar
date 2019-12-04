//
//  Date.swift
//  CalendarComponentTest
//
//  Created by Akaash Dev on 14/12/17.
//  Copyright © 2017 Akaash Dev. All rights reserved.
//

import Foundation

public extension Date {
    /// Initializes date object from date string in format "yyyy MM dd"
    /// - Parameter string : Date string in format "yyyy MM dd" Eg. "2018 12 25"
    init?(fromFormattedString string: String) {
        self.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        guard let date = dateFormatter.date(from: string) else { return nil }
        self.addTimeInterval(date.timeIntervalSince1970 - self.timeIntervalSince1970)
    }
}


extension Date {
    
    init?(timeStamp: TimeInterval, timeZone: TimeZone) {
        self.init(timeIntervalSince1970: timeStamp)
        let unitFlags: Set<Calendar.Component> = [.day, .month, .year, .hour, .minute, .second]
        var comps = Calendar.current.dateComponents(unitFlags, from: self)
        comps.timeZone = timeZone
        guard let date = Calendar.current.date(from: comps) else { return nil }
        self = date
    }
}

struct Formatter {
    static let stdDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    static let stdDateTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
}

extension Date {
    
    var isTodayDate: Bool { return self.equals(date: Date()) }
    
    /// Formats date in the form 'yyyy MM dd'
    var dateFormattedString: String {
        return Formatter.stdDateFormatter.string(from: self)
    }
    
    /// Formats date in the form 'yyyy-MM-dd HH:mm:ss'
    var dateTimeFormattedString: String {
        return Formatter.stdDateTimeFormatter.string(from: self)
    }
    
    /// Formats date in the form 'yyyy-MM-dd  HH:mm:ss zzz'
    func getDateTimeFormattedString(timezone: TimeZone) ->  String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        return dateFormatter.string(from: self) + " \(timezone)"
    }
    
    func equals(date: Date) -> Bool {
        let selfString = self.dateFormattedString
        let otherString = date.dateFormattedString
        return selfString == otherString
    }
    
    func lessThan(date: Date) -> Bool {
        let selfString = self.dateFormattedString
        let otherString = date.dateFormattedString
        return selfString < otherString
    }
    
    func greaterThan(date: Date) -> Bool {
        let selfString = self.dateFormattedString
        let otherString = date.dateFormattedString
        return selfString > otherString
    }
    
    func greaterThanOrEqualTo(date: Date) -> Bool {
        let selfString = self.dateFormattedString
        let otherString = date.dateFormattedString
        return selfString >= otherString
    }
    
    func inBeforeMonths(from date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM"
        let selfString = formatter.string(from: self)
        let otherString = formatter.string(from: date)
        return selfString < otherString
    }
    
    func inAfterMonths(from date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM"
        let selfString = formatter.string(from: self)
        let otherString = formatter.string(from: date)
        return selfString > otherString
    }
    
    func inSameMonth(of date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM"
        let selfString = formatter.string(from: self)
        let otherString = formatter.string(from: date)
        return selfString == otherString
    }
    
    func isSameYear(of date: Date) -> Bool {
        return isSameAsYear(date: date, calendar: Calendar.current)
    }
    
    func isThisYear() -> Bool {
        return isSameYear(of: Date())
    }
    
    func years(from date: Date, in calendar: Calendar? = nil) -> Int {
        let _calendar = calendar ?? Calendar.current
        return _calendar.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    func months(from date: Date, in calendar: Calendar? = nil) -> Int {
        let _calendar = calendar ?? Calendar.current
        return _calendar.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    func weeks(from date: Date, in calendar: Calendar? = nil) -> Int {
        let _calendar = calendar ?? Calendar.current
        return _calendar.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    func days(from date: Date, in calendar: Calendar? = nil) -> Int {
        let _calendar = calendar ?? Calendar.current
        return _calendar.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(from date: Date, in calendar: Calendar? = nil) -> Int {
        let _calendar = calendar ?? Calendar.current
        return _calendar.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date, in calendar: Calendar? = nil) -> Int {
        let _calendar = calendar ?? Calendar.current
        return _calendar.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func seconds(from date: Date, in calendar: Calendar? = nil) -> Int {
        let _calendar = calendar ?? Calendar.current
        return _calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    ///Calculates till hours offset. days, months and years are not calculated here.
    func timeOffsetStringUptoHours(from date: Date, calendar: Calendar? = nil) -> String {
        let hours = self.hours(from: date, in: calendar)
        if hours == 0 {
            let mins = self.minutes(from: date, in: calendar)
            if mins == 0 {
                return "Just now"
            } else {
                if mins == 1 { return "1 min" }
                return "\(mins) mins"
            }
        } else {
            if hours == 1 { return "1 hr" }
            return "\(hours) hrs"
        }
    }
    
    ///Returns the difference from 'fromDate' in the format 1min, 3d, 1m, 2y etc...
    func timeOffsetString(from date: Date, calendar: Calendar? = nil) -> String {
        let yrs = years(from: date, in: calendar)
        if yrs > 0 {
            return "\(yrs) \("year".pluralForm(count: yrs))"
        }
        let mnths = months(from: date, in: calendar)
        if mnths > 0 {
            return "\(mnths) \("month".pluralForm(count: mnths))"
        }
        let wks = weeks(from: date, in: calendar)
        if wks > 0 {
            return "\(wks) \("week".pluralForm(count: wks))"
        }
        let d = days(from: date, in: calendar)
        if d > 0 {
            return "\(d) \("day".pluralForm(count: d))"
        }
        let hrs = hours(from: date, in: calendar)
        if hrs > 0 {
            return "\(hrs) h"
        }
        let mins = minutes(from: date, in: calendar)
        if mins > 0 {
            return "\(mins) m"
        }
        let secs = seconds(from: date, in: calendar)
        if secs > 0 {
            return "\(secs) s"
        }
        return "1 s"
    }
    
    ///Returns the difference from current time in the format 1min, 3d, 1m, 2y etc...
    func timeDifferenceStringFromNow(calendar: Calendar? = nil) -> String {
        return Date().timeOffsetString(from: self, calendar: calendar)
    }
    
}

extension Date {
    
    static let allFlags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year, .weekday, .weekOfYear, .weekdayOrdinal]
    
    static let oneHourTimeInterval: TimeInterval = 60 * 60
    static let oneDayTimeInterval: TimeInterval = 24 * oneHourTimeInterval
    static let oneWeekTimeInterval: TimeInterval = 7 * oneDayTimeInterval
    
    func startOfDay(calendar: Calendar) -> Date {
        
        var comps = calendar.dateComponents(Date.allFlags, from: self)
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        return Calendar.current.date(from: comps)!
    }
    
    func endOfDay(calendar: Calendar) -> Date {
        
        var comps = calendar.dateComponents(Date.allFlags, from: self)
        comps.hour = 23
        comps.minute = 59
        comps.second = 59
        return Calendar.current.date(from: comps)!
    }
    
    func firstDateOfWeek(calendar: Calendar) -> Date {
        
        let components = Set<Calendar.Component>([.weekday])
        let weekdayComponents: DateComponents? = calendar.dateComponents(components, from: self)
        var componentsToSubtract = DateComponents()
        let daysToSubtract: Int? = (((weekdayComponents?.weekday)! - calendar.firstWeekday) + 7) % 7
        componentsToSubtract.day = -1 * daysToSubtract!
        let startOfWeek: Date? = calendar.date(byAdding: componentsToSubtract, to: self)
        return startOfWeek!
    }
    
    func firstDateOfMonth(calendar: Calendar) -> Date {
        
        let currentDateComponents: DateComponents? = calendar.dateComponents([.year, .month], from: self)
        let startOfMonth: Date? = calendar.date(from: currentDateComponents!)
        return startOfMonth!
    }
    
    func endDateOfMonth(calendar: Calendar) -> Date {
        var comps = DateComponents()
        comps.month = 1
        comps.day = -1
        let endOfMonth = calendar.date(byAdding: comps, to: self.firstDateOfMonth(calendar: calendar))
        return endOfMonth!
    }
    
    func dateByWeekDayIndex(index: Int, calendar: Calendar) -> Date {
        
        let nextIndexDate = calendar.date(byAdding: .day, value: index, to: self)  // self.date = self.date + 1 (day)
        return nextIndexDate!
    }
    
    func sameDayInNextWeek(calendar: Calendar) -> Date {
        
        let nextWeekDate = calendar.date(byAdding: .weekOfYear, value: 1, to: self)  // self.date = self.date + 1 (week)
        return nextWeekDate!
    }
    
    func sameDayInNextMonth(calendar: Calendar) -> Date {
        
        let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: self)  // self.date = self.date + 1 (week)
        return nextMonthDate!
    }
    
    func isSameAsDate(date: Date, calendar: Calendar) -> Bool {
        return calendar.compare(date, to: self, toGranularity: .day) == .orderedSame
    }
    
    func isSameAsMonth(date: Date, calendar: Calendar) -> Bool {
        return calendar.compare(date, to: self, toGranularity: .month) == .orderedSame
    }
    
    func isSameAsYear(date: Date, calendar: Calendar) -> Bool {
        return calendar.compare(date, to: self, toGranularity: .year) == .orderedSame
    }
    
    func numDaysInMonth(calendar: Calendar) -> Int {
        return calendar.range(of: .day, in: .month, for: self)?.count ?? 0
    }
    
    func offsetMonth(_ numMonths: Int, calendar: Calendar) -> Date {
        return calendar.date(byAdding: .month, value: numMonths, to: self) ?? Date()
    }
    
    func offsetDay(_ numDays: Int, calendar: Calendar) -> Date {
        return calendar.date(byAdding: .day, value: numDays, to: self) ?? Date()
    }
    
    func weekDay(calendar: Calendar) -> Int {
        return calendar.component(.weekday, from: self)
    }
    
    func day(calendar: Calendar) -> Int {
        return calendar.component(.day, from: self)
    }
    
    func month(calendar: Calendar) -> Int {
        return calendar.component(.month, from: self)
    }
    
    func year(calendar: Calendar) -> Int {
        return calendar.component(.year, from: self)
    }
    
    func HH(calendar: Calendar) -> Int {
        return calendar.component(.hour, from: self)
    }
    
    func mm(calendar: Calendar) -> Int {
        return calendar.component(.minute, from: self)
    }
    
}

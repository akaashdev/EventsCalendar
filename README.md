# EventsCalendar

[![CI Status](https://img.shields.io/travis/akaashdev/EventsCalendar.svg?style=flat)](https://travis-ci.org/akaashdev/EventsCalendar)
[![Version](https://img.shields.io/cocoapods/v/EventsCalendar.svg?style=flat)](https://cocoapods.org/pods/EventsCalendar)
[![License](https://img.shields.io/cocoapods/l/EventsCalendar.svg?style=flat)](https://cocoapods.org/pods/EventsCalendar)
[![Platform](https://img.shields.io/cocoapods/p/EventsCalendar.svg?style=flat)](https://cocoapods.org/pods/EventsCalendar)

Events Calendar is a light-weight iOS Swift library that helps you easily create customizable Calendar UI with events mapping. It supports both sync and async events loading. It is very light and optimized that it allows to achieve ~60 fps rendering easily. Achieves smooth scrolling and takes less memory. The attributes of calendar UI are completely customizable.


## Screenshots
<img align="left" width="200" src="https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_1.png">
<img align="left" width="200" src="https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_2.png">
<img align="left" width="200" src="https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_5.png">
<img align="center" width="200" src="https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_6.png">

<img align="left" width="200" src="https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_3.png">
<img align="center" width="200" src="https://github.com/akaashdev/EventsCalendar/blob/master/Screenshots/screenshot_4.png">


## Usage

### Initialization

**CalendarView** is available in both Week format and Month format. Usage of both the format is similar.
Initialize a **MonthCalendarView** by:

```swift
lazy var monthCalendarView = {
    let view = MonthCalendarView(
        startDate: Date(fromFormattedString: "2000 01 01")!,
        endDate: Date(fromFormattedString: "2050 12 01")!
    )
    view.allowsDateSelection = true // default value: true
    view.selectedDate = Date()
    
    view.isPagingEnabled = true // default value: true
    view.scrollDirection = .horizontal // default value: .horizontal
    view.viewConfiguration = CalendarConfig() // default valut: .default 
    return view
}()
```

**WeekCalendarView** can be initialized the same way.

### Calendar UI configuration

The UI of the calendar is determined by **CalendarConfig** object, which is passed to viewConfiguration property of **CalendarView**.
CalendarConfig consists of more than 25 customizable properties. The properties are: 

```swift
    backgroundColor: UIColor                // background color of calendar

    selectionColor: UIColor                 // selected date background color
    dotColor: UIColor                       // event dot color
    selectedDotColor: UIColor               // event dot color of selected date

    weekendLabelColor: UIColor              // weekend date text color
    validLabelColor: UIColor                // valid date text color 
    invalidLabelColor: UIColor              // invalid date text color
    selectedLabelColor: UIColor             // selected date text color
    todayLabelColor: UIColor                // today date text color
    otherMonthLabelColor: UIColor           // other month date text color

    dateLabelFont: UIFont                   // font of date text

    cellMaxWidth: CGFloat?                  // maximum width of each date cell
    cellMaxHeight: CGFloat?                 // maximum height of each date cell

    invalidatePastDates: Bool               // shows past dates invalid date and unselectable
    shouldConsiderSaturdayAsWeekend: Bool   // considers saturday as weekend

    monthTitleFont: UIFont                  // month title text font
    monthTitleHeight: CGFloat               // month title text height
    monthTitleTextColor: UIColor            // month title text color
    monthTitleAlignment: NSTextAlignment    // month title text alignment
    monthTitleBackgroundColor: UIColor      // month title background color
    monthTitleStyle: MonthTitleStyle        // month title style (short, full, ...)
    monthTitleIncludesYear: Bool            // displays year along with month title
    
    weekdayTitles: [String]                 // week day titles 
    weekdayTitleFont: UIFont                // week day title text font
    weekdayTitleColor: UIColor              // week day title text color
    weekdayTitleHeight: CGFloat             // week day title height
    weekdayTitlesBackgroundColor: UIColor   // week day title background color
```

### CalendarViewDelegate

Callbacks from **CalendarView** are called to delegate. Conform your object to **CalendarViewDelegate** and assign to **delegate** property of **CalendarView**

```
    monthCalendarView.delegate = self   // self should conform to CalendarViewDelegate
```

Each time a date selection is changed, the below method of CalendarViewDelegate is called.
```
    func calendarView(_ calendarView: CalendarProtocol, didChangeSelectionDateTo date: Date, at indexPath: IndexPath)
```

### Events Handling

**EventsCalendar** handles events population both syncronously and asyncronously. **CalendarViewDelegate** has two optional methods for event handling:
```
    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date) -> Set<Int>?
    
    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date, completion: @escaping (Result<Set<Int>, Error>)->())
```

Use the first method if the event days for the current month is readily available.

Use the second method if the event days for the current month must be retreived through a network call or any heavy calculation is required before deciding events for the month. It is advised to do the heavy calculations without blocking the main thread.

### Events Caching

Events caching comes by default in **EventsCalendar** while using events population asyncronously. This helps to reduce redudant network calls or redundant operation for a specific month and improves fast event population in the calendar.
Anyways to turn off event caching, you can use,
```
    monthCalendarView.allowsEventsCaching = false // Default value: true
```


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements

iOS 9.0+


## Installation

EventsCalendar is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EventsCalendar'
```

## Author

Akaash Dev, heatblast.akaash@gmail.com

## License

EventsCalendar is available under the MIT license. See the LICENSE file for more info.

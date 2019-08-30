//
//  ViewController.swift
//  CalendarComponentTest
//
//  Created by Akaash Dev on 24/04/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit
import EventsCalendar

func switchToStyle(_ style: Style) {
    guard let window = UIApplication.shared.keyWindow else { return }
    window.rootViewController = ViewController(style: style)
}

class ViewController: UIViewController {

    let style: Style
    
    init(style: Style = .defaultCalendar) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return style.isDark ? .lightContent : .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = style.backgroundColor
        
        view.addSubview(calendarView)
        view.addSubview(scrollToButton)
        view.addSubview(switchStyleButton)
        
        calendarView.setConstantHuggingWidth(540)
        calendarView.setConstantRestrictingWidth(340)
        
        let widthConstraint = calendarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        widthConstraint.priority = .defaultLow
        widthConstraint.isActive = true
        
        calendarView.fillSuperViewHeight()
        calendarView.alignHorizontallyCenter()
        
        scrollToButton.safeTopAnchor(padding: 12)
        scrollToButton.safeLeadingAnchor(padding: 12)
        
        switchStyleButton.safeTopAnchor(padding: 12)
        switchStyleButton.safeTrailingAnchor(padding: -12)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(
            alongsideTransition: { _ in
                self.calendarView.refreshLayout()
            },
            completion: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarView.scroll(to: Date(), animated: false)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if let flowLayout = calendarView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.itemSize = style.layoutAttributes.itemSize.getTransformed(size: calendarView.bounds.size)
//        }
//    }
    
    
    @objc func scrollToPosition() {
        let today = Date()
        calendarView.selectedDate = today
        calendarView.scroll(to: today)
    }
    
    @objc func handleSwitchCalendarStyleAction() {
        func handleSelectedStyle(_ style: Style) {
            switchToStyle(style)
        }
        let styles = Style.all
        let actions = styles.map { $0.getAlertAction(with: { handleSelectedStyle($0) }) }
        let alert = UIAlertController(title: "Styles", message: nil, preferredStyle: .actionSheet)
        actions.forEach { alert.addAction($0) }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func getButton() -> UIButton {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitleColor(style.calendarConfig.selectionColor, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        view.backgroundColor = style.buttonBackgroundColor
        view.setConstantHeight(28)
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }
    
    private lazy var scrollToButton: UIButton = {
        let view = getButton()
        view.setTitle("   Today   ", for: .normal)
        view.addTarget(self, action: #selector(scrollToPosition), for: .touchUpInside)
        return view
    }()
    
    private lazy var switchStyleButton: UIButton = {
        let view = getButton()
        view.setTitle("   Switch Style   ", for: .normal)
        view.addTarget(self, action: #selector(handleSwitchCalendarStyleAction), for: .touchUpInside)
        return view
    }()
    
    
    private lazy var calendarView: MonthCalendarView = {
        let view = MonthCalendarView(
            startDate: Date(fromFormattedString: "2000 01 01")!,
            endDate: Date(fromFormattedString: "2050 12 01")!
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.allowsDateSelection = true
        view.selectedDate = Date()
        view.delegate = self
        
        let attributes = style.layoutAttributes
        
        view.isPagingEnabled = attributes.pagingEnabled
        view.scrollDirection = attributes.scrollDirection
        view.itemSize = attributes.itemSize
        view.viewConfiguration = style.calendarConfig
        
        view.collectionView.backgroundColor = style.backgroundColor
        view.collectionView.contentInset.top = 60
        view.collectionView.showsVerticalScrollIndicator = false
        if let flowLayout = view.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = attributes.minimumLineSpacing
            flowLayout.minimumInteritemSpacing = attributes.minimumLineSpacing
        }
        
        return view
    }()
    
    private lazy var preheatedFrame: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.8
        view.layer.borderColor = UIColor.green.cgColor
        view.isUserInteractionEnabled = false
        return view
    }()

}

extension ViewController: CalendarViewDelegate {
    
    func calendarView(_ calendarView: CalendarProtocol, didChangeSelectionDateTo date: Date, at indexPath: IndexPath) {
        print("Selection changed to \(date.debugDescription)")
        calendarView.scroll(to: date, animated: true)
    }
    
    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date) -> Set<Int>? {
        return calendarInfo.month % 2 == 0 ? [2, 4, 6, 8, 10, 12, 14, 20, 26, 28]
                        : [5, 7, 11, 15, 21, 32, 27, 25, 23, 1]
    }

//    --- Comment above method and Uncomment below method to simulate Asyncronous event loading ---
//
//    func calendarView(_ calendarView: CalendarProtocol, eventDaysForCalendar type: CalendarViewType, with calendarInfo: CalendarInfo, and referenceDate: Date, completion: @escaping (Result<Set<Int>, Error>) -> ()) {
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            if calendarInfo.month % 2 == 0 {
//                completion(.success([2, 4, 6, 8, 10, 12, 14, 20, 26, 28]))
//            } else {
//                completion(.success([5, 7, 11, 15, 21, 32, 27, 25, 23, 1]))
//            }
//        }
//
//    }
//
    
}


struct LayoutAttributes {
    let itemSize: Size
    let minimumInteritemSpacing: CGFloat
    let minimumLineSpacing: CGFloat
    let pagingEnabled: Bool
    let scrollDirection: UICollectionView.ScrollDirection
}

enum Style {
    static let all: [Style] = [.defaultCalendar, .defaultRedCalendar, .simpleBlueCalendar, .darkFullCalendar, .lightFullCalendar, .darkAmberCalendar, .sportyCalendar]
    
    case defaultCalendar, defaultRedCalendar, simpleBlueCalendar, darkFullCalendar, lightFullCalendar, darkAmberCalendar, sportyCalendar
    
    var title: String {
        switch self {
        case .defaultCalendar: return "Default"
        case .defaultRedCalendar: return "Default Red"
        case .simpleBlueCalendar: return "Simple Blue"
        case .darkFullCalendar: return "Dark"
        case .lightFullCalendar: return "Light"
        case .darkAmberCalendar: return "Amber"
        case .sportyCalendar: return "Sport"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .defaultCalendar, .defaultRedCalendar: return .white
        case .simpleBlueCalendar: return .mildGray
        case .darkFullCalendar: return .black
        case .lightFullCalendar: return .white
        case .darkAmberCalendar: return .amberDark
        case .sportyCalendar: return UIColor(rgb: 0x2C3335) // black
        }
    }
    
    var isDark: Bool {
        switch self {
        case .darkFullCalendar,
             .darkAmberCalendar,
             .sportyCalendar:
            return true
            
        default:
            return false
        }
    }
    
    var buttonBackgroundColor: UIColor {
        return isDark ? UIColor(white: 0.12, alpha: 1)
            : UIColor(white: 0.92, alpha: 1)
    }
    
    var calendarConfig: CalendarConfig {
        switch self {
        case .defaultCalendar: return Config.defaultCalendar
        case .defaultRedCalendar: return Config.defaultRedCalendar
        case .simpleBlueCalendar: return Config.simpleBlueCalendar
        case .darkFullCalendar: return Config.darkFullCalendar
        case .lightFullCalendar: return Config.lightFullCalendar
        case .darkAmberCalendar: return Config.darkAmberCalendar
        case .sportyCalendar: return Config.sportyCalendar
        }
    }
    
    var layoutAttributes: LayoutAttributes {
        switch self {
        case .defaultCalendar, .defaultRedCalendar, .simpleBlueCalendar:
            return LayoutAttributes(
                itemSize: Size(width: .fill, height: .absolute(340)),
                minimumInteritemSpacing: 0,
                minimumLineSpacing: 0,
                pagingEnabled: true,
                scrollDirection: .horizontal
            )
            
        case .darkFullCalendar:
            return LayoutAttributes(
                itemSize: Size(width: .absolute(160), height: .absolute(160)),
                minimumInteritemSpacing: 20,
                minimumLineSpacing: 20,
                pagingEnabled: false,
                scrollDirection: .vertical
            )
            
        case .lightFullCalendar:
            return LayoutAttributes(
                itemSize: Size(width: .absolute(160), height: .absolute(160)),
                minimumInteritemSpacing: 20,
                minimumLineSpacing: 20,
                pagingEnabled: false,
                scrollDirection: .vertical
            )
            
        case .darkAmberCalendar:
            return LayoutAttributes(
                itemSize: Size(width: .fill, height: .absolute(340)),
                minimumInteritemSpacing: 0,
                minimumLineSpacing: 0,
                pagingEnabled: true,
                scrollDirection: .horizontal
            )
            
        case .sportyCalendar:
            return LayoutAttributes(
                itemSize: Size(width: .fill, height: .absolute(400)),
                minimumInteritemSpacing: 0,
                minimumLineSpacing: 0,
                pagingEnabled: true,
                scrollDirection: .horizontal
            )
        }
        
    }
}


enum Config {
    static let defaultCalendar = CalendarConfig.default
    
    static let defaultRedCalendar = CalendarConfig(
        selectionColor: .red,
        dotColor: .red,
        selectedDotColor: .red,
        todayLabelColor: .red,
        weekdayTitleColor: .red
    )
    
    static let simpleBlueCalendar = CalendarConfig(
        backgroundColor: .mildGray,
        selectionColor: UIColor.classicBlue.withAlphaComponent(0.7),
        dotColor: .classicBlue,
        selectedDotColor: .classicBlue,
        weekendLabelColor: .gray,
        validLabelColor: .black,
        invalidLabelColor: .mildGray,
        todayLabelColor: .classicBlue,
        otherMonthLabelColor: .mildGray,
        dateLabelFont: UIFont.systemFont(ofSize: 18, weight: .medium),
        invalidatePastDates: false,
        monthTitleFont: UIFont.systemFont(ofSize: 32, weight: .heavy),
        monthTitleHeight: 40,
        monthTitleTextColor: .black,
        monthTitleAlignment: .right,
        monthTitleBackgroundColor: .mildGray,
        monthTitleStyle: .full,
        monthTitleIncludesYear: false,
        weekdayTitleFont: UIFont.systemFont(ofSize: 14, weight: .bold),
        weekdayTitleColor: .classicBlue,
        weekdayTitleHeight: 16,
        weekdayTitleBackgroundColor: .mildGray
    )
    
    static let darkFullCalendar = CalendarConfig(
        backgroundColor: .black,
        selectionColor: .red,
        dotColor: .red,
        selectedDotColor: .white,
        weekendLabelColor: .gray,
        validLabelColor: .white,
        invalidLabelColor: .lightGray,
        todayLabelColor: .red,
        otherMonthLabelColor: .lightGray,
        dateLabelFont: UIFont.systemFont(ofSize: 11, weight: .medium),
        invalidatePastDates: false,
        monthTitleFont: UIFont.systemFont(ofSize: 16, weight: .heavy),
        monthTitleHeight: 18,
        monthTitleTextColor: .white,
        monthTitleAlignment: .left,
        monthTitleBackgroundColor: .black,
        monthTitleStyle: .short,
        monthTitleIncludesYear: false,
        weekdayTitleFont: UIFont.systemFont(ofSize: 11, weight: .bold),
        weekdayTitleColor: .red,
        weekdayTitleHeight: 13,
        weekdayTitleBackgroundColor: .black
    )
    
    static let lightFullCalendar = CalendarConfig(
        backgroundColor: .white,
        selectionColor: .red,
        dotColor: .red,
        selectedDotColor: .red,
        weekendLabelColor: .gray,
        validLabelColor: .black,
        invalidLabelColor: .white,
        todayLabelColor: .red,
        otherMonthLabelColor: .white,
        dateLabelFont: UIFont.systemFont(ofSize: 11, weight: .medium),
        invalidatePastDates: false,
        monthTitleFont: UIFont.systemFont(ofSize: 18, weight: .heavy),
        monthTitleHeight: 20,
        monthTitleTextColor: .black,
        monthTitleAlignment: .left,
        monthTitleBackgroundColor: .white,
        monthTitleStyle: .full,
        monthTitleIncludesYear: false,
        weekdayTitleFont: UIFont.systemFont(ofSize: 11, weight: .bold),
        weekdayTitleColor: .red,
        weekdayTitleHeight: 13,
        weekdayTitleBackgroundColor: .white
    )
    
    static let darkAmberCalendar = CalendarConfig(
        backgroundColor: .amberDark,
        selectionColor: .amber,
        dotColor: .amber,
        selectedDotColor: .white,
        weekendLabelColor: .lightGray,
        validLabelColor: .white,
        invalidLabelColor: .darkGray,
        todayLabelColor: .amber,
        otherMonthLabelColor: .darkGray,
        dateLabelFont: UIFont.systemFont(ofSize: 18, weight: .medium),
        invalidatePastDates: false,
        monthTitleFont: UIFont.systemFont(ofSize: 32, weight: .heavy),
        monthTitleHeight: 40,
        monthTitleTextColor: .lightGray,
        monthTitleAlignment: .center,
        monthTitleBackgroundColor: .amberDark,
        monthTitleStyle: .full,
        monthTitleIncludesYear: false,
        weekdayTitleFont: UIFont.systemFont(ofSize: 14, weight: .bold),
        weekdayTitleColor: .amber,
        weekdayTitleHeight: 18,
        weekdayTitleBackgroundColor: .amberDark
    )
    
    static let sportyCalendar = CalendarConfig(
        backgroundColor: UIColor(rgb: 0x2C3335), // black
        selectionColor: UIColor(rgb: 0xBA2F16),  // red
        dotColor: UIColor(rgb: 0xBA2F16),  // red
        selectedDotColor: UIColor(rgb: 0xBA2F16),  // red
        weekendLabelColor: UIColor(rgb: 0x7B8788), // gray
        validLabelColor: UIColor(rgb: 0x99AAAB), // light gray
        invalidLabelColor: UIColor(rgb: 0x2C3335), // black
        todayLabelColor: UIColor(rgb: 0xBA2F16),  // red
        otherMonthLabelColor: UIColor(rgb: 0x2C3335), // black
        dateLabelFont: UIFont.italicSystemFont(ofSize: 22),
        invalidatePastDates: false,
        monthTitleFont: UIFont.systemFont(ofSize: 34, weight: .heavy),
        monthTitleHeight: 38,
        monthTitleTextColor: UIColor(rgb: 0x99AAAB), // light gray
        monthTitleAlignment: .right,
        monthTitleBackgroundColor: UIColor(rgb: 0x2C3335), // black
        monthTitleStyle: .full,
        monthTitleIncludesYear: true,
        weekdayTitleFont: UIFont.systemFont(ofSize: 18, weight: .bold),
        weekdayTitleColor: UIColor(rgb: 0xBA2F16),  // red
        weekdayTitleHeight: 20,
        weekdayTitleBackgroundColor: UIColor(rgb: 0x2C3335) // black
    )
}




extension UIColor {
    static let amberDark: UIColor = UIColor(rgb: 0x140f00)
    static let amberLight: UIColor = UIColor(rgb: 0xffbf00)
    static let amber: UIColor = UIColor(rgb: 0xe6ac00)
    
    static let mildGray: UIColor = UIColor(white: 1, alpha: 1)
    static let classicBlue: UIColor = UIColor(rgb: 0x1245a8)
    
    convenience init(red: Float, green: Float, blue: Float) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(pickColorGametRed: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: Float(red), green: Float(green), blue: Float(blue))
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


extension Date {
    init?(fromFormattedString string: String) {
        self.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        guard let date = dateFormatter.date(from: string) else { return nil }
        self.addTimeInterval(date.timeIntervalSince1970 - self.timeIntervalSince1970)
    }
}

extension Style {
    
    func getAlertAction(with responseAction: @escaping (Style)->()) -> UIAlertAction {
        return UIAlertAction(
            title: title,
            style: .default,
            handler: { _ in responseAction(self) }
        )
    }
    
}

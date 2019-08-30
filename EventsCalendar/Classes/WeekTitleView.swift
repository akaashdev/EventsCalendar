//
//  WeekTitleView.swift
//  CalendarComponentTest
//
//  Created by Akaash Dev on 29/04/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit

public class WeekTitleView: UIView {
    
    public var viewConfiguration: WeekTitleViewConfig = CalendarConfig.default {
        didSet {
            refreshDisplay()
        }
    }
    
    public func refreshDisplay() {
        setNeedsDisplay()
        layer.displayIfNeeded()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        refreshDisplay()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        viewConfiguration.weekdayTitlesBackgroundColor.setFill()
        UIRectFill(rect)
        
        let cellWidth = Utils.getCellWidth(for: rect, configuration: viewConfiguration)
        let cellHeight = viewConfiguration.weekdayTitleHeight
        
        for (index, title) in viewConfiguration.weekdayTitles.enumerated() {
            let fontHeight = viewConfiguration.weekdayTitleFont.pointSize
            
            let tileX = CGFloat(index) * cellWidth
            let tileY = (cellHeight / 2) - (fontHeight / 2)
            
            title.draw(
                in: CGRect(
                    x: tileX,
                    y: tileY,
                    width: cellWidth,
                    height: fontHeight
                ),
                with: viewConfiguration.weekdayTitleFont,
                lineBreakMode: .byClipping,
                alignment: .center,
                with: viewConfiguration.weekdayTitleColor,
                backgroundColor: viewConfiguration.weekdayTitlesBackgroundColor
            )
        }
    }
    
}

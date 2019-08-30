//
//  Utils.swift
//  CalendarComponentTest
//
//  Created by Akaash Dev on 24/04/19.
//  Copyright © 2019 Akaash Dev. All rights reserved.
//

import UIKit

func iterate(nTimes n: Int, block: ()->()) {
    for _ in (0 ..< n) {
        block()
    }
}

func runOnMainThread(after delay: TimeInterval, operation: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        operation()
    }
}


func runOnMainThread(_ operaion: @escaping ()->()) {
    DispatchQueue.main.async {
        operaion()
    }
}

func runOnBackgroundThread(_ operaion: @escaping ()->()) {
    DispatchQueue.main.async {
        operaion()
    }
}

extension String {
    
    func pluralForm(count: Int) -> String {
        return count > 1 ? self + "s" : self
    }
    
    func draw(in rect: CGRect, with font: UIFont, lineBreakMode: NSLineBreakMode, alignment: NSTextAlignment, with color: UIColor, backgroundColor: UIColor = .white)  {
        //works for NSLineBreakMode-ByWordWrapping,ByCharWrapping,ByTruncatingTail
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment
        
        if lineBreakMode == NSLineBreakMode.byTruncatingTail {
            self.draw(
                with: rect,
                options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine],
                attributes: [
                    .paragraphStyle: paragraphStyle,
                    .font: font,
                    .foregroundColor: color,
                    .backgroundColor: backgroundColor
                ],
                context: nil
            )
            return
        }
        
        self.draw(
            in: rect,
            withAttributes: [
                .paragraphStyle: paragraphStyle,
                .font: font,
                .foregroundColor: color
            ]
        )
    }
    
    func size(with font: UIFont, constrainedToSize size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        
        return self.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: font], context: nil).size
    }
}



let isDebugMode = true

fileprivate func getFileName(from path: String) -> String {
    return path.components(separatedBy: "/").last ?? ""
}

func logPrint(_ messages: Any?..., classname: String = #file, function: String = #function, line: Int = #line) {
    if isDebugMode {
        messages.forEach {
            print(
                $0 ?? "nil",
                separator: " ",
                terminator: " "
            )
        }
        
        print(
            "  - line[", line, "] -- ", function, " -- ", getFileName(from: classname),
            separator: "",
            terminator: "\n\n"
        )
    }
}

func logError(_ messages: Any?..., classname: String = #file, function: String = #function, line: Int = #line) {
    
    var logContent = ""
    for message in messages {
        print(message ?? "nil", separator: " ", terminator: " ")
        logContent += String(describing: message) + " "
    }
    print("   ERROR @- line[", line, "] -- ", function, " -- ", getFileName(from: classname), separator: "")
    logContent += "   ERROR @- line[\(line)] -- \(function)  -- \(getFileName(from: classname))"
    
}

//
//  UIView.swift
//  CalendarComponentTest
//
//  Created by Akaash Dev on 08/09/17.
//  Copyright © 2017 Akaash Dev. All rights reserved.
//

import UIKit

enum Anchor { case leading, trailing, top, bottom }

extension UIView {
    
//MARK: Anchor methods without SafeLayout Guide
    @discardableResult
    func anchorTop(with view: UIView? = nil, padding: CGFloat = 0) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = topAnchor.constraint(equalTo: viewB.topAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func anchorBottom(with view: UIView? = nil, padding: CGFloat = 0) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = bottomAnchor.constraint(equalTo: viewB.bottomAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func anchorLeading(with view: UIView? = nil, padding: CGFloat = 0) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = leadingAnchor.constraint(equalTo: viewB.leadingAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func anchorTrailing(with view: UIView? = nil, padding: CGFloat = 0) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = trailingAnchor.constraint(equalTo: viewB.trailingAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    //MARK: Constant Dimension methods
    @discardableResult
    func setConstantHeight(_ height: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
        return constraint
    }
    
    
    /// Less than or equal to constant
    @discardableResult
    func setConstantHuggingHeight(_ height: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: height)
        constraint.isActive = true
        return constraint
    }
    
    /// Greater than or equal to constant
    @discardableResult
    func setConstantRestrictingHeight(_ height: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: height)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func setConstantWidth(_ width: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
        return constraint
    }
    
    
    /// Less than or equal to constant
    @discardableResult
    func setConstantHuggingWidth(_ width: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: width)
        constraint.isActive = true
        return constraint
    }
    
    /// Greater than or equal to constant
    @discardableResult
    func setConstantRestrictingWidth(_ width: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: width)
        constraint.isActive = true
        return constraint
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    /// Less than or equal to constant
    func setHuggingDimensions(width: CGFloat, height: CGFloat) {
        widthAnchor.constraint(lessThanOrEqualToConstant: width).isActive = true
        heightAnchor.constraint(lessThanOrEqualToConstant: height).isActive = true
    }
    
    /// Greater than or equal to constant
    func setResistingDimensions(width: CGFloat, height: CGFloat) {
        widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
    }
    
//MARK: Anchor methods with SafeLayout Guide
    @discardableResult
    func safeLeadingAnchor(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            constraint = leadingAnchor.constraint(equalTo: viewB.safeAreaLayoutGuide.leadingAnchor, constant: padding)
            constraint.isActive = true
        }
        else {
            constraint = leadingAnchor.constraint(equalTo: viewB.leadingAnchor, constant: padding)
            constraint.isActive = true
        }
        return constraint
    }
    
    @discardableResult
    func safeTrailingAnchor(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            constraint =  trailingAnchor.constraint(equalTo: viewB.safeAreaLayoutGuide.trailingAnchor, constant: padding)
            constraint.isActive = true
        }
        else {
            constraint = trailingAnchor.constraint(equalTo: viewB.trailingAnchor, constant: padding)
            constraint.isActive = true
        }
        return constraint
    }
    
    @discardableResult
    func safeTopAnchor(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            constraint = topAnchor.constraint(equalTo: viewB.safeAreaLayoutGuide.topAnchor, constant: padding)
            constraint.isActive = true
        } else {
            constraint = topAnchor.constraint(equalTo: viewB.topAnchor, constant: padding)
            constraint.isActive = true
        }
        return constraint
    }
    
    @discardableResult
    func safeBottomAnchor(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint: NSLayoutConstraint
        if #available(iOS 11.0, *) {
            constraint = bottomAnchor.constraint(equalTo: viewB.safeAreaLayoutGuide.bottomAnchor, constant: padding)
        } else {
            constraint = bottomAnchor.constraint(equalTo: viewB.bottomAnchor, constant: padding)
        }
        constraint.isActive = true
        return constraint
    }
    
//MARK: Anchor methods with ReadableLayout Guide
    @discardableResult
    func readableLeadingAnchor(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = leadingAnchor.constraint(equalTo: viewB.readableContentGuide.leadingAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func readableTrailingAnchor(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = trailingAnchor.constraint(equalTo: viewB.readableContentGuide.trailingAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func readableTopAnchor(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = topAnchor.constraint(equalTo: viewB.readableContentGuide.topAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func readableBottomAnchor(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = bottomAnchor.constraint(equalTo: viewB.readableContentGuide.bottomAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
//MARK: Centering View methods
    @discardableResult
    func alignVerticallyCenter(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = centerYAnchor.constraint(equalTo: viewB.centerYAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func alignHorizontallyCenter(padding: CGFloat = 0, with view: UIView? = nil) -> NSLayoutConstraint? {
        guard let viewB = getViewB(from: view) else { return nil }
        let constraint = centerXAnchor.constraint(equalTo: viewB.centerXAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    func alignCenter(xPadding: CGFloat = 0, yPadding: CGFloat = 0) {
        if let view = superview {
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xPadding).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yPadding).isActive = true
        }
    }
    
//MARK: Anchoring Adjacent Views methods
    @discardableResult
    func placeBelow(view: UIView, padding: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func placeAbove(view: UIView, padding: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: view.topAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func placeNextTo(view: UIView, padding: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func placeBeforeTo(view: UIView, padding: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding)
        constraint.isActive = true
        return constraint
    }
    
//MARK: Matching Constraints methods
    func matchAllConstraints(of view: UIView) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func matchAllConstraints(of view: UIView, except ignoredAnchors: Set<Anchor>) {
        if !ignoredAnchors.contains(.leading) { leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true }
        if !ignoredAnchors.contains(.trailing) { trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true }
        if !ignoredAnchors.contains(.top) { topAnchor.constraint(equalTo: view.topAnchor).isActive = true }
        if !ignoredAnchors.contains(.bottom) { bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true }
    }
    
    func matchContraint(_ anchor: Anchor, ofView view: UIView, padding: UIEdgeInsets = .zero) {
        matchContraints([anchor], ofView: view, padding: padding)
    }
    
    func matchContraints(_ anchors: Set<Anchor>, ofView view: UIView, padding: UIEdgeInsets = .zero) {
        if anchors.contains(.top) { topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top).isActive = true }
        if anchors.contains(.leading) { leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.left).isActive = true }
        if anchors.contains(.trailing) { trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding.right).isActive = true }
        if anchors.contains(.bottom) { bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding.bottom).isActive = true }
    }

//MARK: Seperator line methods
    @discardableResult
    func asSeperatorLine(below: UIView, space: CGFloat = 0, padding: CGFloat = 0, color: UIColor = .lightGray) -> NSLayoutConstraint? {
        guard let _ = superview else {
            return nil
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = color
        self.fillSuperViewWidth(padding: padding)
        self.alpha = 0.7
        self.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        let constraint = self.topAnchor.constraint(equalTo: below.bottomAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    func addSeparatorLine(below view: UIView, space: CGFloat = 0, padding: CGFloat = 0, color: UIColor = .lightGray) {
        let line = UIView()
        addSubview(line)
        line.asSeperatorLine(below: view, space: space, padding: padding, color: color)
    }
    
    func addBottomLine(bottomPadding: CGFloat = 0, edgePadding: CGFloat = 0, color: UIColor = .lightGray, lineHeight: CGFloat = 0.8, lineAlpha: CGFloat = 0.7) {
        let line: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = color
            view.alpha = lineAlpha
            view.setConstantHeight(lineHeight)
            return view
        }()
        
        addSubview(line)
        
        line.fillSuperViewWidth(padding: edgePadding)
        line.anchorBottom()
    }
    
//MARK: Fill Superview methods
    func fillSuperViewWidth(padding: CGFloat = 0, safeLayout: Bool = true) {
        if safeLayout {
            safeLeadingAnchor(padding: padding)
            safeTrailingAnchor(padding: -padding)
        } else {
            anchorLeading(padding: padding)
            anchorTrailing(padding: -padding)
        }
    }
    
    func fillSuperViewHeight(padding: CGFloat = 0, safeLayout: Bool = true) {
        if safeLayout {
            safeTopAnchor(padding: padding)
            safeBottomAnchor(padding: -padding)
        } else {
            anchorTop(padding: padding)
            anchorBottom(padding: -padding)
        }
    }
    
    func fillSuperView(padding: CGFloat = 0, safeLayout: Bool = true) {
        fillSuperViewWidth(padding: padding, safeLayout: safeLayout)
        fillSuperViewHeight(padding: padding, safeLayout: safeLayout)
    }
    
//MARK: Fill Superview Readable Layout methods
    func fillSuperViewReadableWidth(padding: CGFloat = 0) {
        readableLeadingAnchor(padding: padding)
        readableTrailingAnchor(padding: -padding)
    }
    
    func fillSuperViewReadableHeight(padding: CGFloat = 0) {
        readableTopAnchor(padding: padding)
        readableBottomAnchor(padding: -padding)
    }
    
    func fillSuperViewWithReadableLayoutGuide(padding: CGFloat = 0) {
        fillSuperViewReadableWidth(padding: padding)
        fillSuperViewReadableHeight(padding: padding)
    }
    
//MARK: Adding Guidelines for reference
    func addGuideLine(xDistance: CGFloat?, yDistance: CGFloat?) {
        if let xDis = xDistance {
            let view: UIView! = {
                let view = UIView()
                view.backgroundColor = UIColor(pickColorGametRed: 0, green: 1, blue: 0, alpha: 0.5)
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            addSubview(view)
            
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xDis.rounded()).isActive = true
            view.fillSuperViewHeight()
            view.widthAnchor.constraint(equalToConstant: 0.25).isActive = true
        }
        
        if let yDis = yDistance {
            let view: UIView! = {
                let view = UIView()
                view.backgroundColor = UIColor(pickColorGametRed: 0, green: 1, blue: 0, alpha: 0.5)
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            
            addSubview(view)
            
            view.topAnchor.constraint(equalTo: topAnchor, constant: yDis.rounded()).isActive = true
            view.fillSuperViewWidth()
            view.heightAnchor.constraint(equalToConstant: 0.25).isActive = true
        }
    }
    
    func addCenterGuideLines() {
        addGuideLine(xDistance: self.frame.width/2, yDistance: self.frame.height/2)
    }
    
    
//MARK: Helper methods
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) } 
    }
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func showTopBorder(thickness: CGFloat = 0.25) {
        let border: UIView! = {
            let view = UIView()
            view.backgroundColor = .lightGray
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        addSubview(border)
        border.fillSuperViewWidth()
        border.topAnchor.constraint(equalTo: topAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
    }
    
    var shadow: Bool {
        get { return layer.shadowOpacity > 0 }
        set {
            if newValue == true {
                self.layer.masksToBounds = false
                self.layer.shadowColor = UIColor.lightGray.cgColor
                self.layer.shadowOpacity = 0.25
                self.layer.shadowOffset = CGSize(width: -1, height: -1)
                self.layer.shadowRadius = 1
            } else { layer.shadowOpacity = 0 }
        }
    }
    
//MARK: Private methods
    private func getViewB(from view: UIView?) -> UIView? {
        if let view = view {
            return view
        }
        if let view = superview {
            return view
        }
        logError("No parent view to anchor with.")
        return nil
    }
    
}

extension UIView {
    func getCurrentScreenImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func renderAsImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


extension UIColor {
    convenience init(pickColorGametRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        if #available(iOS 10.0, *) {
            self.init(
                displayP3Red: red,
                green: green,
                blue: blue,
                alpha: alpha
            )
        } else {
            self.init(
                red: red,
                green: green,
                blue: blue,
                alpha: alpha
            )
        }
    }
}

//
//  UITextField+Styles.swift
//

import Foundation
import UIKit

private var bottomLineColorAssociationKey: UInt8 = 0
private var selectedBottomLineColorAssociationKey: UInt8 = 1
private var errorColorAssociationKey: UInt8 = 2

// Custom UIAppearance properties
extension UITextField {

    override open var accessibilityValue: String? {
        get { return self.text }
        set { super.accessibilityValue = newValue }
    }

    @objc dynamic var placeholderTextColor: UIColor? {
        get {
            return self.placeholderTextColor
        }
        set {
            let placeholderText = placeholder != nil ? placeholder! : ""
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: newValue!])
            setNeedsDisplay()
        }
    }

    @objc dynamic var bottomLineColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &bottomLineColorAssociationKey) as? UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &bottomLineColorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            setNeedsDisplay()
        }
    }

    @objc dynamic var selectedBottomLineColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &selectedBottomLineColorAssociationKey) as? UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &selectedBottomLineColorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            setNeedsDisplay()
        }
    }

    @objc dynamic var errorColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &errorColorAssociationKey) as? UIColor
        }
        set(newValue) {
            objc_setAssociatedObject(self, &errorColorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            setNeedsDisplay()
        }

    }
}

//
//  Builder+Padding.swift
//  ViewBuilder
//
//  Created by Michael Long on 11/9/21.
//

import UIKit


public protocol ViewBuilderPaddable {
    func setPadding(_ padding: UIEdgeInsets)
}


extension ModifiableView where Base: ViewBuilderPaddable {
    
    @discardableResult
    public func padding(_ value: CGFloat) -> ViewModifier<Base> {
        padding(insets: UIEdgeInsets(top: value, left: value, bottom: value, right: value))
    }
    
    @discardableResult
    public func padding(h: CGFloat, v: CGFloat) -> ViewModifier<Base> {
        padding(insets: UIEdgeInsets(top: v, left: h, bottom: v, right: h))
    }
    
    @discardableResult
    public func padding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> ViewModifier<Base> {
        padding(insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    
    @discardableResult
    public func padding(insets: UIEdgeInsets) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.setPadding(insets) }
    }
    
}

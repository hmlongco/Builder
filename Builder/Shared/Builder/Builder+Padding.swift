//
//  Builder+Padding.swift
//  Builder
//
//  Created by Michael Long on 8/16/21.
//

import UIKit


protocol ViewBuilderPaddable {
    
    func padding(insets: UIEdgeInsets) -> Self
    
}

extension ViewBuilderPaddable {
    
    @discardableResult
    func padding(_ value: CGFloat) -> Self {
        return padding(insets: UIEdgeInsets(top: value, left: value, bottom: value, right: value))
    }
    
    @discardableResult
    func padding(h: CGFloat, v: CGFloat) -> Self {
        return padding(insets: UIEdgeInsets(top: v, left: h, bottom: v, right: h))
    }
    
}


extension UIEdgeInsets {
    
    public init(padding: CGFloat) {
        self.init(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    public init(h: CGFloat, v: CGFloat) {
        self.init(top: v, left: h, bottom: v, right: h)
    }
    
}

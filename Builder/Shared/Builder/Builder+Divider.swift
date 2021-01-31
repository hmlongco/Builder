//
//  Builder+Divider.swift
//  Arvest
//
//  Created by Michael Long on 10/30/19.
//  Copyright © 2019 Client Resources Inc. All rights reserved.
//

import UIKit

class DividerView: UIView {

    public init() {
        super.init(frame: .zero)
        let subview = UIView(frame: .zero)
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = UIViewBuilderEnvironment.defaultSeparatorColor
        subview.topAnchor.constraint(equalTo: topAnchor, constant: 4.0).isActive = true
        subview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        subview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        subview.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.5).isActive = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }

    public func dividerColor(_ color: UIColor) -> Self {
        subviews.first?.backgroundColor = color
        return self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    @discardableResult
    public func reference(_ reference: inout DividerView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: DividerView) -> Void) -> Self {
        configuration(self)
        return self
    }
}

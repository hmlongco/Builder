//
//  Builder+View.swift
//  ViewHelpers
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

class SpacerView: UIView {

    public init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    public init(_ height: CGFloat = 16) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    public init(width: CGFloat = 8) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func reference(_ reference: inout SpacerView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: SpacerView) -> Void) -> Self {
        configuration(self)
        return self
    }
}

class FixedSpacerView: UIView {

    public init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentHuggingPriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.required, for: .vertical)
    }

    public init(_ height: CGFloat = 16) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    public init(width: CGFloat = 8) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func reference(_ reference: inout FixedSpacerView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: FixedSpacerView) -> Void) -> Self {
        configuration(self)
        return self
    }
}

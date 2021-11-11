//
//  Builder+View.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

public struct SpacerView: ModifiableView {

    public var modifiableView = Modified(UIView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public init() {
        modifiableView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        modifiableView.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    public init(_ height: CGFloat = 16) {
        modifiableView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        modifiableView.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    public init(width: CGFloat = 8) {
        modifiableView.widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
        modifiableView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
}

public struct FixedSpacerView: ModifiableView {

    public var modifiableView = Modified(UIView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public init() {
        modifiableView.setContentHuggingPriority(.required, for: .horizontal)
        modifiableView.setContentHuggingPriority(.required, for: .vertical)
    }

    public init(_ height: CGFloat = 16) {
        modifiableView.heightAnchor.constraint(equalToConstant: height).isActive = true
        modifiableView.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    public init(width: CGFloat = 8) {
        modifiableView.widthAnchor.constraint(equalToConstant: width).isActive = true
        modifiableView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
}

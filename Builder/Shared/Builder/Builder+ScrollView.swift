//
//  Builder+ScrollView.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/29/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {

    convenience public init(_ view: View?, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        self.init(frame: .zero)
        if let view = view {
            self.embed(view, padding: padding, safeArea: safeArea)
        }
    }

    convenience public init(padding: UIEdgeInsets? = nil, safeArea: Bool = false, @ViewFunctionBuilder _ builder: () -> ViewConvertable) {
        self.init(frame: .zero)
        builder().asViewConvertable().forEach { self.embed($0, padding: padding, safeArea: safeArea) }
    }

    @discardableResult
    public func reference(_ reference: inout UIScrollView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: UIScrollView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

class VerticalScrollView: ScrollView {

    override public func didMoveToWindow() {
        guard let superview = superview, let subview = subviews.first else { return }
        superview.widthAnchor.constraint(equalTo: subview.widthAnchor).isActive = true
    }

}

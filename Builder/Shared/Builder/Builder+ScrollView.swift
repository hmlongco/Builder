//
//  Builder+ScrollView.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/29/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit


public struct ScrollView: ModifiableView {
    
    public var modifiableView = Modified(UIScrollView(frame: UIScreen.main.bounds)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    public init(_ view: View?, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        guard let view = view else { return }
        modifiableView.embed(view, padding: padding, safeArea: safeArea)
    }

    public init(padding: UIEdgeInsets? = nil, safeArea: Bool = false, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        builder().asViews().forEach { modifiableView.embed($0, padding: padding, safeArea: safeArea) }
    }

}

public struct VerticalScrollView: ModifiableView {
    
    public var modifiableView: UIScrollView = Modified(BuilderVerticalScrollView(frame: UIScreen.main.bounds)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    public init(_ view: View?, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        guard let view = view else { return }
        modifiableView.embed(view, padding: padding, safeArea: safeArea)
    }

    public init(padding: UIEdgeInsets? = nil, safeArea: Bool = false, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        builder().asViews().forEach { modifiableView.embed($0, padding: padding, safeArea: safeArea) }
    }

}

fileprivate class BuilderVerticalScrollView: UIScrollView {

    var initialized = false
    
    override public func didMoveToWindow() {
        guard initialized == false, window != nil, let superview = superview, let subview = subviews.first else { return }
        superview.widthAnchor.constraint(equalTo: subview.widthAnchor).isActive = true
        initialized = true
    }

}

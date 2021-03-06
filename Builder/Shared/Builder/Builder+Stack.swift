//
//  StackBuilder.swift
//  ViewHelpers
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit

extension UIStackView {

    public func addArrangedSubviews(_ views: View?...) {
        self.addArrangedSubviews(views)
    }

    public func addArrangedSubviews(_ views: [View?]) {
        for view in views {
            if let view = view {
                self.addArrangedSubview(view)
            }
        }
    }

    public func reset(to view: View) {
        empty()
        addArrangedSubview(view)
    }

    public func reset(to views: [View]) {
        empty()
        addArrangedSubviews(views)
    }

    @discardableResult
    public func alignment(_ alignment: Alignment) -> Self {
        self.alignment = alignment
        return self
    }

    @discardableResult
    public func distribution(_ distribution: Distribution) -> Self {
        self.distribution = distribution
        return self
    }

    @discardableResult
    public func padding(_ padding: UIEdgeInsets) -> Self {
        self.layoutMargins = padding
        self.isLayoutMarginsRelativeArrangement = true
        return self
    }

    @discardableResult
    public func spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

}

class VStackView: UIStackView {

    public init(_ convertableViews: [ViewConvertable]) {
         super.init(frame: .zero)
         self.translatesAutoresizingMaskIntoConstraints = false
         self.axis = .vertical
         self.alignment = .fill
         self.distribution = .fill
         if #available(iOS 11, *) {
             self.spacing = UIStackView.spacingUseSystem
         } else {
             self.spacing = 8
         }
        self.addArrangedSubviews(convertableViews.asViews())
    }

//    private var builder: AnyIndexableViewBuilder?

    convenience public init(_ builder: AnyIndexableViewBuilder) {
        self.init(builder.asViews())
//        self.builder = builder
//        self.builder?.onChange { [weak self] in
//            self?.reset(to: builder.build())
//        }
    }

    convenience public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        self.init(builder().asViews())
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func reference(_ reference: inout VStackView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: UIStackView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

class HStackView: UIStackView {

   public init(_ convertableViews: [ViewConvertable]) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
        if #available(iOS 11, *) {
            self.spacing = UIStackView.spacingUseSystem
        } else {
            self.spacing = 8
        }
        self.addArrangedSubviews(convertableViews.asViews())
    }

    //    private var builder: AnyIndexableViewBuilder?

        convenience public init(_ builder: AnyIndexableViewBuilder) {
            self.init(builder.asViews())
    //        self.builder = builder
    //        self.builder?.onChange { [weak self] in
    //            self?.reset(to: builder.build())
    //        }
        }

    convenience public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        self.init(builder().asViews())
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func reference(_ reference: inout HStackView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: HStackView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

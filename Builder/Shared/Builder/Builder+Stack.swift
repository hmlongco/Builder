//
//  StackBuilder.swift
//  ViewHelpers
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

class VStackView: UIStackView {

    public init(_ convertableViews: [ViewConvertable]) {
        super.init(frame: .zero)
        self.commonSetup(axis: .vertical)
        self.addArrangedSubviews(convertableViews.asViews())
    }

    convenience public init(_ builder: AnyIndexableViewBuilder) {
        self.init(builder.asViews())
        subscribe(to: builder)
    }

    convenience public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        self.init(builder().asViews())
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class HStackView: UIStackView {

   public init(_ convertableViews: [ViewConvertable]) {
        super.init(frame: .zero)
        self.commonSetup(axis: .horizontal)
        self.addArrangedSubviews(convertableViews.asViews())
    }

    convenience public init(_ builder: AnyIndexableViewBuilder) {
        self.init(builder.asViews())
        subscribe(to: builder)
    }

    convenience public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        self.init(builder().asViews())
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension UIStackView: ViewBuilderPaddable {

    @discardableResult
    public func padding(insets: UIEdgeInsets) -> Self {
        self.layoutMargins = insets
        self.isLayoutMarginsRelativeArrangement = true
        return self
    }

}

extension UIStackView {
    
    fileprivate func commonSetup(axis: NSLayoutConstraint.Axis) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = UIStackView.spacingUseSystem
    }
            
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
    public func spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

    @discardableResult
    func subscribe(to builder: AnyIndexableViewBuilder) -> Self {
        builder.updated?
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] views in
                self?.reset(to: builder.asViews())
            })
            .disposed(by: rxDisposeBag)
        return self
    }
    
    @discardableResult
    public func reference(_ reference: inout UIStackView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: UIStackView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

//
//  LabelBuilder.swift
//  ViewHelpers
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

class LabelView: UILabel {

    public init(_ text: String?) {
        super.init(frame: .zero)
        self.common()
        self.text = text
    }

    public init(_ text: String?, configuration: (_ view: UILabel) -> Void) {
        super.init(frame: .zero)
        self.common()
        self.text = text
        configuration(self)
    }

    public init(_ text: Observable<String>) {
        super.init(frame: .zero)
        self.common()
        self.bind(text: text)
    }

    public init(_ text: Observable<String?>) {
        super.init(frame: .zero)
        self.common()
        self.bind(text: text)
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func common() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIViewBuilderEnvironment.defaultLabelFont ?? UIFont.preferredFont(forTextStyle: .callout)
        self.textColor = UIViewBuilderEnvironment.defaultLabelColor ?? textColor
        self.textAlignment = .left
        self.adjustsFontForContentSizeCategory = true
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

}

extension LabelView {

    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    @discardableResult
    public func bind(color: Observable<UIColor>) -> Self {
        color
            .subscribe(onNext: { [weak self] (color) in
                self?.textColor = color
            })
            .disposed(by: self.rxDisposeBag)
        return self
    }

    @discardableResult
    public func bind(text: Observable<String>) -> Self {
        text
            .subscribe { [weak self] (text) in
                self?.text = text
            }
        .disposed(by: rxDisposeBag)
        return self
    }

    @discardableResult
    public func bind(text: Observable<String?>) -> Self {
        text
            .subscribe { [weak self] (text) in
                self?.text = text
            }
            .disposed(by: rxDisposeBag)
        return self
    }

    @discardableResult
    public func color(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    @discardableResult
    public func font(_ font: UIFont?) -> Self {
        self.font = font ?? self.font
        return self
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> Self {
        self.font = .preferredFont(forTextStyle: style)
        return self
    }

    @discardableResult
    public func numberOfLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        self.lineBreakMode = .byWordWrapping
        return self
    }

    @discardableResult
    public func reference(_ reference: inout LabelView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: LabelView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

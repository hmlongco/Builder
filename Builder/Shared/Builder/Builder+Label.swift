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

    struct Style {
        let style: (_ button: LabelView) -> ()
    }

    var labelMargins: UIEdgeInsets = .zero
    
    // lifecycle

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

    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == String {
        super.init(frame: .zero)
        self.common()
        self.bind(text: binding)
    }

    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == String? {
        super.init(frame: .zero)
        self.common()
        self.bind(text: binding)
    }

    public init(_ text: Variable<String>) {
        super.init(frame: .zero)
        self.common()
        self.bind(text: text)
    }

    public init(_ text: Variable<String?>) {
        super.init(frame: .zero)
        self.common()
        self.bind(text: text)
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func common() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = ViewBuilderEnvironment.defaultLabelFont ?? UIFont.preferredFont(forTextStyle: .callout)
        self.textColor = ViewBuilderEnvironment.defaultLabelColor ?? textColor
        self.textAlignment = .left
        self.adjustsFontForContentSizeCategory = true
        self.setContentCompressionResistancePriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // support for label padding
    
    override var intrinsicContentSize: CGSize {
        numberOfLines = 0       // don't forget!
        var s = super.intrinsicContentSize
        s.height = s.height + labelMargins.top + labelMargins.bottom
        s.width = s.width + labelMargins.left + labelMargins.right
        return s
    }

    override func drawText(in rect:CGRect) {
        let r = rect.inset(by: labelMargins)
        super.drawText(in: r)
    }

    override func textRect(forBounds bounds:CGRect, limitedToNumberOfLines n: Int) -> CGRect {
        let b = bounds
        let tr = b.inset(by: labelMargins)
        let ctr = super.textRect(forBounds: tr, limitedToNumberOfLines: 0)
        // that line of code MUST be LAST in this function, NOT first
        return ctr
    }

    // custom attributes
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
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

    // standard attributes

    @discardableResult
    public func reference(_ reference: inout LabelView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func style(_ style: Style) -> Self {
        style.style(self)
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: LabelView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

extension LabelView {
    
    @discardableResult
    public func bind<Binding:RxBinding>(color binding: Binding) -> Self where Binding.T == UIColor {
        rxBinding(binding, view: self) { $0.textColor = $1 }
        return self
    }
    
    @discardableResult
    public func bind<Binding:RxBinding>(text binding: Binding) -> Self where Binding.T == String {
        rxBinding(binding, view: self) { $0.text = $1 }
        return self
    }

    @discardableResult
    public func bind<Binding:RxBinding>(text binding: Binding) -> Self where Binding.T == String? {
        rxBinding(binding, view: self) { $0.text = $1 }
        return self
    }

}

extension LabelView: ViewBuilderPaddable {

    @discardableResult
    public func padding(insets: UIEdgeInsets) -> Self {
        self.labelMargins = insets
        return self
    }

}

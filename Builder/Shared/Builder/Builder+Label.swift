//
//  Builder+Label.swift
//  ViewBuilder
//
//  Created by Michael Long on 11/8/21.
//

import UIKit

// Custom builder fot UILabel
public struct LabelView: ModifiableView {
    
    public struct Style {
        public let style: (_ label: ViewModifier<UILabel>) -> ()
    }

    public let modifiableView = Modified(BuilderInternalUILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = ViewBuilderEnvironment.defaultLabelFont ?? UIFont.preferredFont(forTextStyle: .callout)
        $0.textColor = ViewBuilderEnvironment.defaultLabelColor ?? $0.textColor
        $0.textAlignment = .left
        $0.adjustsFontForContentSizeCategory = true
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // lifecycle
    public init(_ text: String?) {
        modifiableView.text = text
    }
    
    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == String {
        self.text(bind: binding)
    }

    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == String? {
        self.text(bind: binding)
    }

    public init(_ text: Variable<String>) {
        self.text(bind: text)
    }

    public init(_ text: Variable<String?>) {
        self.text(bind: text)
    }

    // deprecated
    public init(_ text: String?, configuration: (_ view: Base) -> Void) {
        modifiableView.text = text
        configuration(modifiableView)
    }
    
}


// Custom UILabel modifiers
extension ModifiableView where Base: UILabel {
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.textAlignment, value: alignment)
    }

    @discardableResult
    public func color(_ color: UIColor?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.textColor, value: color)
    }
    
    @discardableResult
    public func font(_ font: UIFont?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.font, value: font)
    }
    
    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.font, value: .preferredFont(forTextStyle: style))
    }

    @discardableResult
    public func numberOfLines(_ numberOfLines: Int) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.numberOfLines = numberOfLines
            $0.lineBreakMode = .byWordWrapping
        }
    }

    @discardableResult
    public func style(_ style: LabelView.Style) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { style.style(ViewModifier($0)) }
    }

}


extension LabelView {
    
    @discardableResult
    public func color<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == UIColor {
        ViewModifier(modifiableView, binding: binding, keyPath: \.textColor)
    }
    
    @discardableResult
    public func text<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == String {
        ViewModifier(modifiableView, binding: binding) { $0.text = $1 } // binding non-optional to optional
    }

    @discardableResult
    public func text<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == String? {
        ViewModifier(modifiableView, binding: binding, keyPath: \.text)
    }

}


public class BuilderInternalUILabel: UILabel {

    var labelMargins: UIEdgeInsets = .zero
    
//    deinit {
//        print("deinit BuilderInternalUILabel")
//    }
    
    // support for label padding
    
    override public var intrinsicContentSize: CGSize {
        numberOfLines = 0       // don't forget!
        var s = super.intrinsicContentSize
        s.height = s.height + labelMargins.top + labelMargins.bottom
        s.width = s.width + labelMargins.left + labelMargins.right
        return s
    }

    override public func drawText(in rect:CGRect) {
        let r = rect.inset(by: labelMargins)
        super.drawText(in: r)
    }

    override public func textRect(forBounds bounds:CGRect, limitedToNumberOfLines n: Int) -> CGRect {
        let b = bounds
        let tr = b.inset(by: labelMargins)
        let ctr = super.textRect(forBounds: tr, limitedToNumberOfLines: 0)
        // that line of code MUST be LAST in this function, NOT first
        return ctr
    }

}

extension BuilderInternalUILabel: ViewBuilderPaddable {

    public func setPadding(_ padding: UIEdgeInsets) {
        labelMargins = padding
    }
    
}


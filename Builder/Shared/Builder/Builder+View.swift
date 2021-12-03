//
//  Builder+View.swift
//  ViewBuilder
//
//  Created by Michael Long on 11/8/21.
//

import UIKit
import RxSwift

// Allows UIView to use basic view modifiers and integrate with view builders
extension UIView: ModifiableView {
    
    public var modifiableView: UIView {
        self
    }
    
    public func build() -> UIView {
        self
    }
    
    public func asViews() -> [UIView] {
        [self]
    }
    
}

extension ModifiableView {

    @discardableResult
    public func set<T>(keyPath: ReferenceWritableKeyPath<Base, T>, value: T) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: keyPath, value: value)
    }

}

// Standard UIView modifiers for all view types
extension ModifiableView {
        
    @discardableResult
    public func accessibilityIdentifier<T:RawRepresentable>(_ accessibilityIdentifier: T) -> ViewModifier<Base> where T.RawValue == String {
        ViewModifier(modifiableView) { $0.accessibilityIdentifier = accessibilityIdentifier.rawValue }
    }
    
    @discardableResult
    public func alpha(_ alpha: CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.alpha, value: alpha)
    }

    @discardableResult
    public func backgroundColor(_ color: UIColor?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.backgroundColor, value: color)
    }

    @discardableResult
    public func border(color: UIColor, lineWidth: CGFloat = 0.5) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.layer.borderColor = color.cgColor
            $0.layer.borderWidth = lineWidth
        }
    }

    @discardableResult
    public func clipsToBounds(_ clips: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.clipsToBounds, value: clips)
    }

    @discardableResult
    public func contentMode(_ contentMode: UIView.ContentMode) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.contentMode, value: contentMode)
    }

    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.layer.cornerRadius = radius
            $0.clipsToBounds = true
        }
    }

    @discardableResult
    public func hidden(_ hidden: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.isHidden, value: hidden)
    }
    
    @discardableResult
    public func identifier<T:RawRepresentable>(_ identifier: T) -> ViewModifier<Base> where T.RawValue == String {
        ViewModifier(modifiableView) { $0.accessibilityIdentifier = identifier.rawValue }
    }

    @discardableResult
    public func roundedCorners(radius: CGFloat, corners: CACornerMask) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.layer.maskedCorners = corners
            $0.layer.cornerRadius = radius
        }
    }
    
    @discardableResult
    public func shadow(color: UIColor, radius: CGFloat, opacity: Float = 0.5, offset: CGSize = .zero) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.layer.shadowColor = color.cgColor
            $0.layer.shadowOffset = offset
            $0.layer.shadowRadius = radius
            $0.layer.shadowOpacity = opacity
            $0.clipsToBounds = false
        }
    }

    @discardableResult
    public func tag<T:RawRepresentable>(_ tag: T) -> ViewModifier<Base> where T.RawValue == Int {
        ViewModifier(modifiableView, keyPath: \.tag, value: tag.rawValue)
    }

    @discardableResult
    public func tintColor(_ color: UIColor) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.tintColor, value: color)
    }

    @discardableResult
    public func translatesAutoresizingMaskIntoConstraints(_ translate: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.translatesAutoresizingMaskIntoConstraints, value: translate)
    }

    @discardableResult
    public func userInteractionEnabled(_ enabled: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.isUserInteractionEnabled, value: enabled)
    }
    
}



extension ModifiableView {
    
    @discardableResult
    public func hidden<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding, keyPath: \.isHidden)
    }

    @discardableResult
    public func userInteractionEnabled<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding, keyPath: \.isUserInteractionEnabled)
    }

}


class BuilderHostView: UIView {
    
    public init(_ view: View) {
        super.init(frame: .zero)
        self.embed(view)
    }

    public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        super.init(frame: .zero)
        builder().asViews().forEach { self.embed($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

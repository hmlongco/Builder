//
//  Builder+Controls.swift
//  Arvest
//
//  Created by Michael Long on 11/25/21.
//  Copyright © 2021 Client Resources Inc. All rights reserved.
//

import UIKit

extension ModifiableView where Base: UIControl {

    @discardableResult
    public func contentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.contentHorizontalAlignment, value: alignment)
    }

    @discardableResult
    public func contentVerticalAlignment(_ alignment: UIControl.ContentVerticalAlignment) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.contentVerticalAlignment, value: alignment)
    }

    @discardableResult
    public func enabled(_ enabled: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.isEnabled, value: enabled)
    }

    @discardableResult
    public func highlighted(_ highlighted: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.isEnabled, value: highlighted)
    }

    @discardableResult
    public func selected(_ selected: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.isEnabled, value: selected)
    }

}

extension ModifiableView where Base: UIControl {

    @discardableResult
    public func enabled<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding) { $0.isEnabled = $1 }
    }

    @discardableResult
    public func highlighted<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding) { $0.isHighlighted = $1 }
    }

    @discardableResult
    public func selected<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding) { $0.isSelected = $1 }
    }

}

//
//  Builder+TextField.swift
//  Builder
//
//  Created by Michael Long on 11/21/21.
//

import Foundation
import UIKit


public struct TextField: ModifiableView {

    public let modifiableView: UITextField = Modified(UITextField()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    // lifecycle
    public init() {

    }

    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == String? {
        text(bind: binding)
    }

    public init<Binding:RxBidirectionalBinding>(_ binding: Binding) where Binding.T == String? {
        text(bidirectionalBind: binding)
    }

}


extension ModifiableView where Base: UITextField {

    @discardableResult
    public func placeholder(_ placeholder: String?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.placeholder, value: placeholder)
    }

    @discardableResult
    public func text<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == String? {
        ViewModifier(modifiableView, binding: binding, keyPath: \.text)
    }

    @discardableResult
    public func text<Binding:RxBidirectionalBinding>(bidirectionalBind binding: Binding) -> ViewModifier<Base> where Binding.T == String? {
        let modifier = ViewModifier(modifiableView, binding: binding, keyPath: \.text)
        modifiableView.rx.text
            .changed
            .bind(to: binding.asRelay())
            .disposed(by: modifiableView.rxDisposeBag)
        return modifier
    }

}

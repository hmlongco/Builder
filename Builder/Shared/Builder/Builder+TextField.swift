//
//  Builder+TextField.swift
//  Builder
//
//  Created by Michael Long on 11/21/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public struct TextField: ModifiableView {

    public let modifiableView: UITextField = Modified(UITextField()) {
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    // lifecycle
    public init() {

    }

    public init(_ text: String?) {
        modifiableView.text = text
    }
    
    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == String? {
        text(bind: binding)
    }

    public init<Binding:RxBidirectionalBinding>(_ binding: Binding) where Binding.T == String {
        text(bidirectionalBind: binding)
    }

    public init<Binding:RxBidirectionalBinding>(_ binding: Binding) where Binding.T == String? {
        text(bidirectionalBind: binding)
    }

}


extension ModifiableView where Base: UITextField {

    @discardableResult
    public func autocapitalizationType(_ type: UITextAutocapitalizationType) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.autocapitalizationType, value: type)
    }

    @discardableResult
    public func autocorrectionType(_ type: UITextAutocorrectionType) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.autocorrectionType, value: type)
    }

    @discardableResult
    public func enablesReturnKeyAutomatically(_ enabled: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.enablesReturnKeyAutomatically, value: enabled)
    }

    @discardableResult
    public func inputView(_ view: UIView?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.inputView, value: view)
    }

    @discardableResult
    public func inputAccessoryView(_ view: UIView?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.inputAccessoryView, value: view)
    }

    @discardableResult
    public func keyboardType(_ type: UIKeyboardType) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.keyboardType, value: type)
    }

    @discardableResult
    public func placeholder(_ placeholder: String?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.placeholder, value: placeholder)
    }

    @discardableResult
    public func returnKeyType(_ returnKeyType: UIReturnKeyType) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.returnKeyType, value: returnKeyType)
    }

    @discardableResult
    public func secureTextEntry(_ secure: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.isSecureTextEntry, value: secure)
    }

    @discardableResult
    public func textContentType(_ textContentType: UITextContentType) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.textContentType, value: textContentType)
    }

}

extension ModifiableView where Base: UITextField {

    @discardableResult
    public func text<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == String? {
        ViewModifier(modifiableView, binding: binding, keyPath: \.text)
    }

    @discardableResult
    public func text<Binding:RxBidirectionalBinding>(bidirectionalBind binding: Binding) -> ViewModifier<Base> where Binding.T == String {
        ViewModifier(modifiableView) { textField in
            let relay = binding.asRelay()
            textField.rxDisposeBag.insert(
                relay
                    .subscribe(onNext: { [weak textField] text in
                        if let textField = textField, textField.text != text {
                            textField.text = text
                        }
                    }),
                textField.rx.text
                    .subscribe(onNext: { [weak relay] text in
                        if let relay = relay, relay.value != text {
                            relay.accept(text ?? "")
                        }
                    })
            )
        }
    }

    @discardableResult
    public func text<Binding:RxBidirectionalBinding>(bidirectionalBind binding: Binding) -> ViewModifier<Base> where Binding.T == String? {
        ViewModifier(modifiableView) { textField in
            let relay = binding.asRelay()
            textField.rxDisposeBag.insert(
                relay
                    .subscribe(onNext: { [weak textField] text in
                        if let textField = textField, textField.text != text {
                            textField.text = text
                        }
                    }),
                textField.rx.text
                    .subscribe(onNext: { [weak relay] text in
                        if let relay = relay, relay.value != text {
                            relay.accept(text)
                        }
                    })
            )
        }
    }
}


extension ModifiableView where Base: UITextField {

    @discardableResult
    public func onChange(_ handler: @escaping (_ context: ViewBuilderValueContext<UITextField, String?>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.rx.controlEvent(.editingChanged)
                .subscribe(onNext: { [unowned modifiableView] () in
                    handler(ViewBuilderValueContext(view: modifiableView, value: modifiableView.text))
                })
                .disposed(by: $0.rxDisposeBag)
        }
    }

    @discardableResult
    public func onEditingDidEnd(_ handler: @escaping (_ context: ViewBuilderValueContext<UITextField, String?>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.rx.controlEvent([.editingDidEnd])
                .subscribe(onNext: { [unowned modifiableView] () in
                    handler(ViewBuilderValueContext(view: modifiableView, value: modifiableView.text))
                })
                .disposed(by: $0.rxDisposeBag)
        }
    }

    @discardableResult
    public func onEditingDidEndOnExit(_ handler: @escaping (_ context: ViewBuilderValueContext<UITextField, String?>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.rx.controlEvent([.editingDidEndOnExit])
                .subscribe(onNext: { [unowned modifiableView] () in
                    handler(ViewBuilderValueContext(view: modifiableView, value: modifiableView.text))
                })
                .disposed(by: $0.rxDisposeBag)
        }
    }

}

//
//  Builder+Switch.swift
//  ViewBuilder
//
//  Created by Michael Long on 11/9/21.
//

import UIKit


// Custom builder fot UILabel
public struct SwitchView: ModifiableView {
    
    public let modifiableView: UISwitch = Modified(UISwitch()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.onTintColor = ViewBuilderEnvironment.defaultButtonColor
    }
    
    // lifecycle
    public init(_ isOn: Bool = true) {
        modifiableView.isOn = isOn
    }
    
    public init<Binding:RxBinding>(_ binding: Binding) where Binding.T == Bool {
        isOn(bind: binding)
    }
    
    public init<Binding:RxBidirectionalBinding>(_ binding: Binding) where Binding.T == Bool {
        isOn(bidirectionalBind: binding)
    }
    
}


// Custom UILabel modifiers
extension ModifiableView where Base: UISwitch {
    
    @discardableResult
    public func isOn<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding, keyPath: \.isOn)
    }
    
    @discardableResult
    public func isOn<Binding:RxBidirectionalBinding>(bidirectionalBind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        let modifier = ViewModifier(modifiableView, binding: binding, keyPath: \.isOn)
        modifiableView.rx.isOn
            .changed
            .bind(to: binding.relay)
            .disposed(by: modifiableView.rxDisposeBag)
        return modifier
    }
    
    @discardableResult
    public func onTintColor(_ color: UIColor?) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.onTintColor, value: color)
    }
        
    @discardableResult
    public func onChange(_ handler: @escaping (_ isOn: Bool) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.rx.isOn
                .changed
                .subscribe(onNext: { isOn in
                    handler(isOn)
                })
                .disposed(by: $0.rxDisposeBag)
        }
    }

    
}

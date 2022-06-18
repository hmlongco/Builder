//
//  MetaTextField.swift
//  Builder
//
//  Created by Michael Long on 12/7/21.
//

import UIKit
import Builder
import RxSwift
import RxRelay

public struct MetaTextField: ModifiableView {

    public let modifiableView = Modified(BuilderInternalTextField()) {
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.bottomLineColor = .gray
        $0.selectedBottomLineColor = .blue
        $0.errorColor = .red
    }

    // lifecycle
    public init() {
        // with later binding
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

extension ModifiableView where Base: BuilderInternalTextField {

    @discardableResult
    func error<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == String? {
        ViewModifier(modifiableView) {
            binding.asObservable()
                .skip(1)
                .observe(on: ConcurrentMainScheduler.instance)
                .map { $0 ?? "" }
                .bind(to: $0.errorText)
                .disposed(by: $0.rxDisposeBag)
        }
    }

    @discardableResult
    func maxWidth(_ width: Int) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.behavior = MaxWidthTextFieldBehavior(width) }
    }

    @discardableResult
    func mask(_ mask: String) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.behavior = MaskedTextFieldBehavior(mask) }
    }

}

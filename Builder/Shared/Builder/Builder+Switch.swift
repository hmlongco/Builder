//
//  Builder+Switch
//  ViewHelpers
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SwitchView: UISwitch {

    public init(_ isOn: Bool = true, configuration: (_ view: SwitchView) -> Void) {
        super.init(frame: .zero)
        self.isOn = isOn
        common()
        configuration(self)
    }
    
    public init<Binding:RxBinding>(isOn binding: Binding) where Binding.T == Bool {
        super.init(frame: .zero)
        common()
        self.bind(isOn: binding)
    }
    
    public init<Binding:RxBidirectionalBinding>(_ binding: Binding) where Binding.T == Bool {
        super.init(frame: .zero)
        common()
        self.bidirectionalBind(isOn: binding)
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func common() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.onTintColor = ViewBuilderEnvironment.defaultButtonColor
    }
    
    @discardableResult
    public func bind<Binding:RxBinding>(isOn binding: Binding) -> Self where Binding.T == Bool {
        rxBinding(binding, view: self) { $0.isOn = $1 }
        return self
    }

    @discardableResult
    public func bidirectionalBind<Binding:RxBidirectionalBinding>(isOn binding: Binding) -> Self where Binding.T == Bool {
        rxBinding(binding, view: self) { $0.isOn = $1 }
        rx.isOn
            .changed
            .bind(to: binding.relay)
            .disposed(by: rxDisposeBag)
        return self
    }

    @discardableResult
    public func onChange(_ handler: @escaping (_ isOn: Bool) -> Void) -> Self {
        rx.isOn
            .changed
            .subscribe(onNext: { isOn in
                handler(isOn)
            })
            .disposed(by: rxDisposeBag)
        return self
    }

    @discardableResult
    public func reference(_ reference: inout SwitchView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: SwitchView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

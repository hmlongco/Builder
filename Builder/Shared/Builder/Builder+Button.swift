//
//  Builder+Button
//  ViewBuilder
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


public struct ButtonView: ModifiableView {
    
    public struct Context: ViewBuilderContextProvider {
        var view: UIButton
    }
    
    public struct Style {
        let style: (_ button: ViewModifier<UIButton>) -> ()
    }

    public let modifiableView = Modified(UIButton()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleColor(ViewBuilderEnvironment.defaultButtonColor ?? $0.tintColor, for: .normal)
        $0.titleLabel?.font = ViewBuilderEnvironment.defaultButtonFont ?? .preferredFont(forTextStyle: .headline)
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    // lifecycle
    public init(_ title: String? = nil) {
        modifiableView.setTitle(title, for: .normal)
    }
    
    // deprecated
    public init(_ title: String? = nil, configuration: (_ view: Base) -> Void) {
        modifiableView.setTitle(title, for: .normal)
        configuration(modifiableView)
    }

}


// Custom UIImageView modifiers
extension ModifiableView where Base: UIButton {

    @discardableResult
    public func alignment(_ alignment: UIControl.ContentHorizontalAlignment) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.contentHorizontalAlignment, value: alignment)
    }

    @discardableResult
    public func buttonBackgroundColor(_ color: UIColor) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.setBackgroundImage(UIImage(color: color), for: .normal) }
    }

    @discardableResult
    public func color(_ color: UIColor, for state: UIControl.State = .normal) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.setTitleColor(color, for: state) }
    }

    @discardableResult
    public func enabled(_ enabled: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.isEnabled, value: enabled)
    }

    @discardableResult
    public func font(_ font: UIFont?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.titleLabel?.font = font }
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.titleLabel?.font = .preferredFont(forTextStyle: style) }
    }

    @discardableResult
    public func onTap(_ handler: @escaping (_ context: ButtonView.Context) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { [unowned modifiableView] view in
            view.rx.tap
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe(onNext: { () in handler(ButtonView.Context(view: modifiableView)) })
                .disposed(by: view.rxDisposeBag)
        }
    }

    @discardableResult
    public func style(_ style: ButtonView.Style) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { style.style(ViewModifier($0)) }
    }

}

extension ModifiableView where Base: UIButton {

    @discardableResult
    public func enabled<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding) { $0.isEnabled = $1 }
    }

    @discardableResult
    public func selected<Binding:RxBinding>(bind binding: Binding) -> ViewModifier<Base> where Binding.T == Bool {
        ViewModifier(modifiableView, binding: binding) { $0.isSelected = $1 }
    }

}

extension UIButton: ViewBuilderPaddable {
    
    public func setPadding(_ padding: UIEdgeInsets) {
        self.contentEdgeInsets = padding
    }

}

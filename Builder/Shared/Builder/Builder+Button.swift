//
//  Builder+Button
//  ViewHelpers
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ButtonView: UIButton {
    
    struct Context: ViewBuilderContextProvider {
        var view: ButtonView
    }
    
    struct Style {
        let style: (_ button: ButtonView) -> ()
    }

    public init(_ title: String? = nil) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        common()
    }

    public init(_ title: String? = nil, configuration: (_ view: ButtonView) -> Void) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        common()
        configuration(self)
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func common() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleColor(ViewBuilderEnvironment.defaultButtonColor ?? tintColor, for: .normal)
        self.titleLabel?.font = ViewBuilderEnvironment.defaultButtonFont ?? .preferredFont(forTextStyle: .headline)
        self.setContentHuggingPriority(.required, for: .horizontal)
    }

    @discardableResult
    public func alignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = alignment
        return self
    }

    @discardableResult
    public func buttonBackgroundColor(_ color: UIColor) -> Self {
        self.setBackgroundImage(UIImage(color: color), for: .normal)
        return self
    }

    @discardableResult
    public func color(_ color: UIColor) -> Self {
        self.setTitleColor(color, for: .normal)
        return self
    }

    @discardableResult
    public func font(_ font: UIFont?) -> Self {
        self.titleLabel?.font = font
        return self
    }

    @discardableResult
    public func font(_ style: UIFont.TextStyle) -> Self {
        self.titleLabel?.font = .preferredFont(forTextStyle: style)
        return self
    }

    @discardableResult
    public func onTap(_ handler: @escaping (_ context: Context) -> Void) -> Self {
        self.rx.tap
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] () in handler(Context(view: self)) })
            .disposed(by: rxDisposeBag)
        return self
    }

    @discardableResult
    public func reference(_ reference: inout ButtonView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func style(_ style: Style) -> Self {
        style.style(self)
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: ButtonView) -> Void) -> Self {
        configuration(self)
        return self
    }

}


extension ButtonView: ViewBuilderPaddable {

    @discardableResult
    public func padding(insets: UIEdgeInsets) -> Self {
        self.contentEdgeInsets = insets
        return self
    }

}

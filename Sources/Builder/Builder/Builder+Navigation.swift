//
//  Builder+Navigation.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/4/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

extension UINavigationController {

    @discardableResult
    public func push(view: View, animated: Bool) -> Self {
        pushViewController(UIViewController(view), animated: animated)
        return self
    }

}

extension ModifiableView {

    @discardableResult
    public func navigation(title: String?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.builderAttributes()?.onAppearOnceHandlers.append({ context in
                context.navigationItem?.title = title
            })
        }
    }

}

extension UIBarButtonItem {

    convenience public init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }

    convenience public init(image: UIImage?, style: UIBarButtonItem.Style) {
        self.init(image: image, style: style, target: nil, action: nil)
    }

    convenience public init(title: String?, style: UIBarButtonItem.Style) {
        self.init(title: title, style: style, target: nil, action: nil)
    }

    @discardableResult
    public func onTap(_ handler: @escaping (_ item: UIBarButtonItem) -> Void) -> Self {
        self.rx.tap
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] () in handler(self) })
            .disposed(by: rxDisposeBag)
        return self
    }

}

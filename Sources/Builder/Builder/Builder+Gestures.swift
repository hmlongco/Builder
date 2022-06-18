//
//  Builder+Gestures.swift
//  Builder
//
//  Created by Michael Long on 11/28/21.
//

import UIKit
import RxSwift

public struct BuilderTapGestureContext<Base:UIView>: ViewBuilderContextProvider {
    public var view: Base
    public var gesture: UIGestureRecognizer
}

public struct BuilderSwipeGestureContext<Base:UIView>: ViewBuilderContextProvider {
    public var view: Base
    public var gesture: UISwipeGestureRecognizer
}

extension ModifiableView {

    @discardableResult
    public func onTapGesture(numberOfTaps: Int = 1, _ handler: @escaping (_ context: BuilderTapGestureContext<Base>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view in
            let gesture = UITapGestureRecognizer()
            gesture.numberOfTapsRequired = numberOfTaps
            view.addGestureRecognizer(gesture)
            view.isUserInteractionEnabled = true
            gesture.rx.event
                .asControlEvent()
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe { [weak view, weak gesture] (e) in
                    guard let view = view, let gesture = gesture else { return }
                    let context = BuilderTapGestureContext(view: view, gesture: gesture)
                    handler(context)
                }
                .disposed(by: view.rxDisposeBag)
        }
    }

    @discardableResult
    public func onSwipeLeft(_ handler: @escaping (_ context: BuilderSwipeGestureContext<Base>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view in
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = .left
            view.addGestureRecognizer(gesture)
            view.isUserInteractionEnabled = true
            gesture.rx.event
                .asControlEvent()
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe { [weak view, weak gesture] (e) in
                    guard let view = view, let gesture = gesture else { return }
                    let context = BuilderSwipeGestureContext(view: view, gesture: gesture)
                    handler(context)
                }
                .disposed(by: view.rxDisposeBag)
        }
    }

    @discardableResult
    public func onSwipeRight(_ handler: @escaping (_ context: BuilderSwipeGestureContext<Base>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view in
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = .right
            view.addGestureRecognizer(gesture)
            view.isUserInteractionEnabled = true
            gesture.rx.event
                .asControlEvent()
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe { [weak view, weak gesture] (e) in
                    guard let view = view, let gesture = gesture else { return }
                    let context = BuilderSwipeGestureContext(view: view, gesture: gesture)
                    handler(context)
                }
                .disposed(by: view.rxDisposeBag)
        }
    }

    @discardableResult
    public func hideKeyboardOnBackgroundTap(cancelsTouchesInView: Bool = true) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view in
            let gesture = UITapGestureRecognizer()
            gesture.numberOfTapsRequired = 1
            gesture.cancelsTouchesInView = cancelsTouchesInView
            view.addGestureRecognizer(gesture)
            gesture.rx.event
                .asControlEvent()
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe { [weak view] _ in
                    view?.endEditing(true)
                }
                .disposed(by: view.rxDisposeBag)
        }
    }


}

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
        ViewModifier(modifiableView) {
            let gesture = UITapGestureRecognizer()
            gesture.numberOfTapsRequired = numberOfTaps
            $0.addGestureRecognizer(gesture)
            let context = BuilderTapGestureContext(view: $0, gesture: gesture)
            gesture.rx.event
                .asControlEvent()
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe { (e) in
                    handler(context)
                }
                .disposed(by: $0.rxDisposeBag)
        }
    }

    @discardableResult
    public func onSwipeLeft(_ handler: @escaping (_ context: BuilderSwipeGestureContext<Base>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = .left
            $0.addGestureRecognizer(gesture)
            let context = BuilderSwipeGestureContext(view: $0, gesture: gesture)
            gesture.rx.event
                .asControlEvent()
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe { (e) in
                    handler(context)
                }
                .disposed(by: $0.rxDisposeBag)
        }
    }

    @discardableResult
    public func onSwipeRight(_ handler: @escaping (_ context: BuilderSwipeGestureContext<Base>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = .right
            $0.addGestureRecognizer(gesture)
            let context = BuilderSwipeGestureContext(view: $0, gesture: gesture)
            gesture.rx.event
                .asControlEvent()
                .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
                .subscribe { (e) in
                    handler(context)
                }
                .disposed(by: $0.rxDisposeBag)
        }
    }

}

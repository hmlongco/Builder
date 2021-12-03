//
//  Builder+RxSwift.swift
//  ViewBuilder
//
//  Created by Michael Long on 11/9/21.
//

import UIKit
import RxSwift
import RxCocoa


public protocol RxBinding {
    associatedtype T
    func asObservable() -> Observable<T>
}

extension Observable: RxBinding {
    // previously defined
}




public protocol RxBidirectionalBinding: RxBinding {
    associatedtype T
    func asRelay() -> BehaviorRelay<T>
}

extension BehaviorRelay: RxBidirectionalBinding {
    public func asRelay() -> BehaviorRelay<Element> { self }
}



extension ViewModifier {
    
    public init<B:RxBinding, T>(_ view: Base, binding: B, handler: @escaping (_ view: Base, _ value: T) -> Void) where B.T == T {
        self.modifiableView = view
        binding.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak view] value in
                if let view = view {
                    handler(view, value)
                }
            })
            .disposed(by: view.rxDisposeBag)
    }
        
    public init<B:RxBinding, T:Equatable>(_ view: Base, binding: B, keyPath: ReferenceWritableKeyPath<Base, T>) where B.T == T {
        self.modifiableView = view
        binding.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak view] value in
                if let view = view, view[keyPath: keyPath] != value {
                    view[keyPath: keyPath] = value
                }
            })
            .disposed(by: view.rxDisposeBag)
    }

}

extension ModifiableView {

    @discardableResult
    public func bind<B:RxBinding, T>(keyPath: ReferenceWritableKeyPath<Base, T>, binding: B) -> ViewModifier<Base> where B.T == T {
        ViewModifier(modifiableView) {
            binding.asObservable()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak modifiableView] value in
                    modifiableView?[keyPath: keyPath] = value
                })
                .disposed(by: $0.rxDisposeBag)
        }
    }

    @discardableResult
    public func onReceive<B:RxBinding, T>(_ binding: B, handler: @escaping (_ context: ViewBuilderContext<Base>, _ value: T) -> Void)
        -> ViewModifier<Base> where B.T == T {
            ViewModifier(modifiableView) {
                binding.asObservable()
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak modifiableView] value in
                        if let view = modifiableView {
                            handler(ViewBuilderContext(view: view), value)
                        }
                    })
                    .disposed(by: $0.rxDisposeBag)
            }
    }

}

extension NSObject {

    private static var RxDisposeBagAttributesKey: UInt8 = 0

    public var rxDisposeBag: DisposeBag {
        if let disposeBag = objc_getAssociatedObject( self, &UIView.RxDisposeBagAttributesKey ) as? DisposeBag {
            return disposeBag
        }
        let disposeBag = DisposeBag()
        objc_setAssociatedObject(self, &UIView.RxDisposeBagAttributesKey, disposeBag, .OBJC_ASSOCIATION_RETAIN)
        return disposeBag
    }

}


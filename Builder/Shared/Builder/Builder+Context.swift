//
//  Builder+Context.swift
//  Builder+Context
//
//  Created by Michael Long on 9/4/21.
//

import UIKit
import RxSwift

public protocol ViewBuilderContextProvider {
    associatedtype Base: UIView
    var view: Base { get }
}

public protocol ViewBuilderContextValueProvider: ViewBuilderContextProvider {
    associatedtype Value
    var value: Value { get }
}

extension ViewBuilderContextProvider {
    
    public var viewController: UIViewController? {
        view.parentViewController
    }
    
    public var navigationController: UINavigationController? {
        viewController?.navigationController
    }
    
    public func present(_ view: View, animated: Bool = true) {
        navigationController?.present(UIViewController(view.build()), animated: animated)
    }
    
    public func present<VC:UIViewController>(_ vc: VC, configure: ((_ vc: VC) -> Void)? = nil) {
        viewController?.present(vc, configure: configure)
    }

    public func push(_ view: View, animated: Bool = true) {
        navigationController?.pushViewController(UIViewController(view.build()), animated: animated)
    }

    public func push<VC:UIViewController>(_ vc: VC, configure: ((_ vc: VC) -> Void)? = nil) {
        viewController?.push(vc, configure: configure)
    }

    public func transition(to view: View, delay: Double = 0.2) {
        self.view.transition(to: view, delay: delay)
    }

    public func transition(to viewController: UIViewController, delay: Double = 0.2) {
        view.transition(to: viewController, delay: delay)
    }

    public func endEditing() {
        view.rootView().endEditing(true)
    }

    public var disposeBag: DisposeBag {
        view.rxDisposeBag
    }

}

// simple extensions to make context calls shorter

extension ViewBuilderContextProvider {

    // goes to top of view chain, then initiates full search of view tree
    public func find<K:RawRepresentable>(_ key: K) -> UIView? where K.RawValue == Int {
        view.find(key)
    }
    public func find<K:RawRepresentable>(_ key: K) -> UIView? where K.RawValue == String {
        view.find(key)
    }

    // searches down the tree looking for identifier
    public func find<K:RawRepresentable>(subview key: K) -> UIView? where K.RawValue == Int {
        view.find(subview: key)
    }
    public func find<K:RawRepresentable>(subview key: K) -> UIView? where K.RawValue == String {
        view.find(subview: key)
    }

    // searches up the tree looking for identifier in superview path
    public func find<K:RawRepresentable>(superview key: K) -> UIView? where K.RawValue == Int {
        view.find(superview: key)
    }
    public func find<K:RawRepresentable>(superview key: K) -> UIView? where K.RawValue == String {
        view.find(superview: key)
    }

}

public struct ViewBuilderContext<Base:UIView>: ViewBuilderContextProvider {
    public var view: Base
}

public struct ViewBuilderValueContext<Base:UIView, Value>: ViewBuilderContextValueProvider {
    public let view: Base
    public var value: Value
}

extension UIView {
    public var context: ViewBuilderContext<UIView> {
        ViewBuilderContext(view: self)
    }
}

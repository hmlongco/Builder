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

extension ViewBuilderContextProvider {
    
    public var viewController: UIViewController? {
        let firstViewController = sequence(first: view, next: { $0.next }).first(where: { $0 is UIViewController })
        return firstViewController as? UIViewController
    }
    
    public var navigationController: UINavigationController? {
        viewController?.navigationController
    }
    
    public var disposeBag: DisposeBag {
        view.rxDisposeBag
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

extension UIView {
    public var context: ViewBuilderContext<UIView> {
        ViewBuilderContext(view: self)
    }
}

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
        navigationController?.present(UIViewController(view.asUIView()), animated: animated)
    }
    
    public func present<VC:UIViewController>(_ vc: VC, configure: ((_ vc: VC) -> Void)? = nil) {
        viewController?.present(vc, configure: configure)
    }

    public func push(_ view: View, animated: Bool = true) {
        navigationController?.pushViewController(UIViewController(view.asUIView()), animated: animated)
    }

    public func push<VC:UIViewController>(_ vc: VC, configure: ((_ vc: VC) -> Void)? = nil) {
        viewController?.push(vc, configure: configure)
    }
    
}

extension ViewBuilderContextProvider {

    // goes to top of view chain, then initiates full search of view tree
    public func findViewWithIdentifier(_ identifier: String) -> UIView? {
        return view.recursiveFind(identifier, keyPath: \.accessibilityIdentifier, in: view.rootView())
    }

    // searches up the tree looking for identifier in superview path
    public func superviewWithIdentifier(_ identifier: String) -> UIView? {
        return view.superviewFind(identifier, keyPath: \.accessibilityIdentifier)
    }

    // searches subviews looking for identifier (similar to UIKit viewWithTag)
    public func viewWithIdentifier(_ identifier: String) -> UIView? {
        return view.recursiveFind(identifier, keyPath: \.accessibilityIdentifier, in: view)
    }

    // goes to top of view chain, then initiates full search of view tree
    public func findViewWithTag(_ tag: Int) -> UIView? {
        return view.recursiveFind(tag, keyPath: \.tag, in: view.rootView())
    }

    // searches up the tree looking for tag in superview path
    public func superviewWithTag(_ tag: Int) -> UIView? {
        return view.superviewFind(tag, keyPath: \.tag)
    }

    // goes to top of view chain, then initiates full search of view tree
    public func viewWithTag(_ tag: Int) -> UIView? {
        return view.viewWithTag(tag)
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

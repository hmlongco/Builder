//
//  Builder+Context.swift
//  Builder+Context
//
//  Created by Michael Long on 9/4/21.
//

import UIKit

protocol ViewBuilderContextProvider {
    associatedtype View: UIView
    var view: View { get }
}

extension ViewBuilderContextProvider {
    
    var viewController: UIViewController? {
        let firstViewController = sequence(first: view, next: { $0.next }).first(where: { $0 is UIViewController })
        return firstViewController as? UIViewController
    }
    
    var navigationController: UINavigationController? {
        viewController?.navigationController
    }
    
    func present(_ builder: ViewBuilder, animated: Bool = true) {
        navigationController?.present(UIViewController(builder), animated: animated)
    }
    
    func present<VC:UIViewController>(_ vc: VC, configure: ((_ vc: VC) -> Void)? = nil) {
        viewController?.present(vc, configure: configure)
    }

    func push(_ builder: ViewBuilder, animated: Bool = true) {
        navigationController?.pushViewController(UIViewController(builder), animated: animated)
    }

    func push<VC:UIViewController>(_ vc: VC, configure: ((_ vc: VC) -> Void)? = nil) {
        viewController?.push(vc, configure: configure)
    }
    
}

struct ViewBuilderContext<View:UIView>: ViewBuilderContextProvider {
    var view: View
}

extension UIView {
    var context: ViewBuilderContext<UIView> {
        ViewBuilderContext(view: self)
    }
}

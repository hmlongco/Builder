//
//  Builder+Context.swift
//  Builder+Context
//
//  Created by Michael Long on 9/4/21.
//

import UIKit
import RxSwift

protocol ViewBuilderContextProvider {
    associatedtype Base: UIView
    var view: Base { get }
}

extension ViewBuilderContextProvider {
    
    var viewController: UIViewController? {
        let firstViewController = sequence(first: view, next: { $0.next }).first(where: { $0 is UIViewController })
        return firstViewController as? UIViewController
    }
    
    var navigationController: UINavigationController? {
        viewController?.navigationController
    }
    
    var disposeBag: DisposeBag {
        view.rxDisposeBag
    }
    
    func present(_ view: View, animated: Bool = true) {
        navigationController?.present(UIViewController(view.asUIView()), animated: animated)
    }
    
    func present<VC:UIViewController>(_ vc: VC, configure: ((_ vc: VC) -> Void)? = nil) {
        viewController?.present(vc, configure: configure)
    }

    func push(_ view: View, animated: Bool = true) {
        navigationController?.pushViewController(UIViewController(view.asUIView()), animated: animated)
    }

    func push<VC:UIViewController>(_ vc: VC, configure: ((_ vc: VC) -> Void)? = nil) {
        viewController?.push(vc, configure: configure)
    }
    
}

struct ViewBuilderContext<Base:UIView>: ViewBuilderContextProvider {
    var view: Base
}

extension UIView {
    var context: ViewBuilderContext<UIView> {
        ViewBuilderContext(view: self)
    }
}

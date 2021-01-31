//
//  Builder+Navigation.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/4/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit


extension UINavigationController {

    @discardableResult
    public func push(view: View, animated: Bool) -> Self {
        pushViewController(UIViewController(view: view), animated: animated)
        return self
    }

}


extension UIView {

    var currentNavigationController: UINavigationController? {
        return currentViewController?.navigationController
    }

    var currentViewController: UIViewController? {
        let firstViewController = sequence(first: self, next: { $0.next }).first(where: { $0 is UIViewController })
        return firstViewController as? UIViewController
    }

}

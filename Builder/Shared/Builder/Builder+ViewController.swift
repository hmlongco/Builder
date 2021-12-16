//
//  Builder+ViewController.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/4/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit

extension UIViewController {

    convenience public init(_ view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        self.init()
        if #available(iOS 13, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            self.view.backgroundColor = .white
        }
        self.view.embed(view.build(), padding: padding, safeArea: safeArea)
    }
    
    public func transition(to page: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false, delay: Double = 0.2) {
        view.transition(to: page, padding: padding, safeArea: safeArea, delay: delay)
    }

    public func transition(to viewController: UIViewController, delay: Double) {
        view.transition(to: viewController, delay: delay)
    }

}


struct ViewControllerHostView: ViewBuilder {
    let viewController: UIViewController
    var body: View {
        ContainerView()
            .onAppearOnce { context in
                context.transition(to: viewController)
            }
    }
}

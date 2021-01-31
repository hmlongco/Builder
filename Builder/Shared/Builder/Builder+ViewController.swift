//
//  Builder+ViewController.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/4/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit

extension UIViewController {

    convenience public init(view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        self.init()
        self.view.backgroundColor = .systemBackground
        self.view.embed(view, padding: padding, safeArea: safeArea)
    }

}

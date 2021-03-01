//
//  StandardLoadingPage.swift
//  Builder
//
//  Created by Michael Long on 3/1/21.
//

import UIKit
import Resolver
import RxSwift

struct StandardLoadingPage: UIViewBuilder {

    func build() -> View {
        return VerticalScrollView {
            VStackView {
                indicator()
                SpacerView()
            }
            .padding(UIEdgeInsets(padding: 16))
        }
        .backgroundColor(.systemBackground)
    }

    func indicator() -> View {
        let indicator = UIActivityIndicatorView()
        indicator.color = .systemGray
        indicator.startAnimating()
        return indicator
    }

}

//
//  StandardLoadingPage.swift
//  Builder
//
//  Created by Michael Long on 3/1/21.
//

import UIKit
import Resolver
import RxSwift

struct StandardLoadingPage: ViewBuilder {

    func build() -> View {
        return VerticalScrollView {
            VStackView {
                With(UIActivityIndicatorView()) {
                    $0.color = .systemGray
                    $0.startAnimating()
                }
                SpacerView()
            }
            .padding(16)
        }
        .backgroundColor(.systemBackground)
    }

}

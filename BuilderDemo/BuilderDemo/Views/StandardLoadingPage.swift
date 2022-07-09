//
//  StandardLoadingPage.swift
//  Builder
//
//  Created by Michael Long on 3/1/21.
//

import UIKit
import Builder
import Factory
import RxSwift

struct StandardLoadingPage: ViewBuilder {

    var body: View {
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

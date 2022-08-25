//
//  LoginViewController.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Builder
import Factory
import RxSwift
import RxCocoa

struct LoadingCardView: ViewBuilder {
    var body: View {
        DLSCardView {
            VStackView {
                With(UIActivityIndicatorView()) {
                    $0.startAnimating()
                }
            }
            .padding(16)
        }
    }
}

//
//  LoginCardView.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Builder
import Factory
import RxSwift
import RxCocoa

struct LoginCardView: ViewBuilder {

    let viewModel: LoginViewModel

    var body: View {
        DLSCardView {
            VStackView {
                LabelView("Welcome")
                    .alignment(.center)
                    .font(.headline)
                    .color(.label)

                LoginErrorView(error: viewModel.$error)

                VStackView {
                    TextField(viewModel.$username)
                        .placeholder("Login ID")
                        .set(keyPath: \.borderStyle, value: .roundedRect) // properties w/o dedicated builder
                        .set(keyPath: \.textContentType, value: .username) // properties w/o dedicated builder
                        .tag(456) // testing identifiers
                    LabelView(viewModel.$usernameError)
                        .font(.footnote)
                        .color(.red)
                        .hidden(bind: viewModel.hideUsernameError)
                        .padding(h: 8, v: 0)
                }
                .spacing(2)

                VStackView {
                    TextField(viewModel.$password)
                        .placeholder("Password")
                        .set(keyPath: \.borderStyle, value: .roundedRect) // properties w/o dedicated builder
                        .set(keyPath: \.textContentType, value: .password) // properties w/o dedicated builder
                        .set(keyPath: \.isSecureTextEntry, value: true) // properties w/o dedicated builder
                    LabelView(viewModel.$passwordError)
                        .font(.footnote)
                        .color(.red)
                        .hidden(bind: viewModel.hidePasswordError)
                        .padding(h: 8, v: 0)
                }
                .spacing(2)

                VStackView {
                    ButtonView("Login") {  [weak viewModel] _ in
                        viewModel?.login()
                    }
                    .style(StyleButtonFilled())

                    ButtonView("Enroll / Login Help") { context in
                        print(context.view.find(superview: "dlscard")!) // testing identifiers
                        print(context.view.find(456)!) // testing identifiers
                    }
                    .height(44)
                }
                .spacing(6)

            }
            .padding(top: 30, left: 40, bottom: 16, right: 40)
            .spacing(20)
        }
    }
}

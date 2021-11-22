//
//  LoginViewController.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Resolver
import RxSwift


class LoginViewController: UIViewController {

    var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login Demo"
        view.backgroundColor = .systemBackground
        view.embed(LoginView(viewModel: viewModel))
    }

}


struct LoginView: ViewBuilder {

    let viewModel: LoginViewModel

    func build() -> View {
        VerticalScrollView {
            ZStackView {
                UIView()
                    .translatesAutoresizingMaskIntoConstraints(false)
                    .backgroundColor(.darkGray)
                    .position(.top)
                    .height(200)

                VStackView {
                    DLSCardView {
                        VStackView {
                            VStackView {
                                TextField(viewModel.$username)
                                    .placeholder("Username")
                                    .with {
                                        $0.borderStyle = .roundedRect
                                        $0.textContentType = .username
                                   }
                                LabelView(viewModel.$usernameError)
                                    .font(.footnote)
                                    .color(.red)
                                    .hidden(bind: viewModel.$usernameError.asObservable().map { $0 == nil })
                            }
                            .spacing(2)

                            VStackView {
                                TextField(viewModel.$password)
                                    .placeholder("Password")
                                    .with {
                                        $0.borderStyle = .roundedRect
                                        $0.textContentType = .password
                                        $0.isSecureTextEntry = true
                                    }
                                LabelView(viewModel.$passwordError)
                                    .font(.footnote)
                                    .color(.red)
                                    .hidden(bind: viewModel.$passwordError.asObservable().map { $0 == nil })
                            }
                            .spacing(2)

                            VStackView {
                                ButtonView("Login")
                                    .style(.filled)

                                ButtonView("Login Help")
                                    .onTap { [weak viewModel] _ in
                                        UIView.animate(withDuration: 0.3) {
                                            viewModel?.usernameError = "Required"
                                            viewModel?.passwordError = "Required"
                                        }
                                    }
                            }
                            .spacing(6)

                       }
                        .spacing(20)
                        .padding(top: 30, left: 20, bottom: 20, right: 20)
                    }

                    SpacerView()
                }
                .padding(top: 100, left: 20, bottom: 20, right: 20)
                .spacing(50)
            }

        }
        .backgroundColor(.secondarySystemFill)
    }
    
}

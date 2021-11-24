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
        title = ""
        view.backgroundColor = .secondarySystemBackground
        view.embed(LoginView(viewModel: viewModel))

        let test1 = view.viewWithIdentifier("dlscard")!
        print(test1)
        let test2 = view.viewWithTag(456)!
        print(test2)
    }

}


struct LoginView: ViewBuilder {

    let viewModel: LoginViewModel

    func build() -> View {
        VerticalScrollView {
            ZStackView {
                ZStackView {
                    LabelView("Login Demo")
                        .alignment(.center)
                        .font(.headline)
                        .color(.white)
                        .tag(100)
                        .position(.top)
                        .height(50)
                }
                .translatesAutoresizingMaskIntoConstraints(false)
                .backgroundColor(.black)
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
                                    .tag(456) // testing identifiers
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
                                    .onTap { [weak viewModel] _ in
                                        UIView.animate(withDuration: 0.3) {
                                            viewModel?.login()
                                        }
                                    }

                                ButtonView("Login Help")
                                    .onTap { context in
                                        context.view.findViewWithTag(456)?.alpha = 0.5
//                                        print(context.view.superviewWithIdentifier("dlscard")!) // testing identifiers
//                                        print(context.view.superviewWithTag(456)!) // testing identifiers
                                    }
                            }
                            .spacing(6)

                        }
                        .spacing(20)
                        .padding(top: 30, left: 20, bottom: 20, right: 20)
                    }
                    .accessibilityIdentifier("dlscard") // testing identifiers

                    ContainerView()
                        .height(600)

                    SpacerView()
                }
                .padding(top: 100, left: 20, bottom: 20, right: 20)
                .spacing(50)
            }

        }
        .backgroundColor(.systemBackground)
        .bounces(false)
        .onDidScroll { context in
            let y = context.view.contentOffset.y
            if y > 50 {
                context.viewController?.navigationItem.title = "Login Demo"
                context.viewWithTag(100)?.alpha = 0
            } else {
                context.viewController?.navigationItem.title = ""
                context.viewWithTag(100)?.alpha = 1 - ((y * 2) / 100)
            }
        }
    }

}

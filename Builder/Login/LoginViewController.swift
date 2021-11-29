//
//  LoginViewController.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Resolver
import RxSwift


fileprivate enum IDS: String {
    case dlscard
    case logo
}


class LoginViewController: UIViewController {

    var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        view.backgroundColor = .secondarySystemBackground
        view.embed(LoginView(viewModel: viewModel))

        let test1 = view.find(subview: "dlscard")!
        print(test1)
        let test2 = view.find(subview: IDS.dlscard)!
        print(test2)
        let test3 = view.find(subview: 456)!
        print(test3)
    }

}


struct LoginView: ViewBuilder {

    let viewModel: LoginViewModel

    var body: View {
        ZStackView {
            ImageView(UIImage(named: "vector2"))

            VerticalScrollView {
                ZStackView {
                    ContainerView {
                        LabelView("Login Demo")
                            .accessibilityIdentifier(IDS.logo)
                            .alignment(.center)
                            .font(.headline)
                            .color(.white)
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
                                        .set(keyPath: \.borderStyle, value: .roundedRect) // properties w/o dedicated builder
                                        .set(keyPath: \.textContentType, value: .username) // properties w/o dedicated builder
                                        .tag(456) // testing identifiers
                                    LabelView(viewModel.$usernameError)
                                        .font(.footnote)
                                        .color(.red)
                                        .hidden(bind: viewModel.$usernameError.asObservable().map { $0 == nil })
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
                                        .hidden(bind: viewModel.$passwordError.asObservable().map { $0 == nil })
                                        .padding(h: 8, v: 0)
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
                                            print(context.view.find(superview: "dlscard")!) // testing identifiers
                                            print(context.view.find(456)!) // testing identifiers
                                        }
                                }
                                .spacing(6)

                            }
                            .spacing(20)
                            .padding(top: 30, left: 20, bottom: 20, right: 20)
                        }
                        .accessibilityIdentifier(IDS.dlscard) // testing identifiers

                        ContainerView()
                            .height(600)

                        SpacerView()
                    }
                    .padding(top: 100, left: 20, bottom: 20, right: 20)
                    .spacing(50)
                }

            }
            .backgroundColor(.clear)
            .bounces(false)
            .onDidScroll { context in
                let y = context.view.contentOffset.y
                if y > 50 {
                    context.viewController?.navigationItem.title = "Login Demo"
                    context.find(IDS.logo)?.alpha = 0
                } else {
                    context.viewController?.navigationItem.title = ""
                    context.find(IDS.logo)?.alpha = 1 - ((y * 2) / 100)
                }
            }
        }
    }

}

//
//  LoginViewController.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Resolver
import RxSwift
import RxCocoa

fileprivate enum IDS: String {
    case dlscard
    case logoBlock
}

class LoginViewController: UIViewController {

    var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        view.backgroundColor = .secondarySystemBackground
        view.embed(LoginView(viewModel: viewModel))

//        navigationItem.hidesBackButton = true

//        let test1 = view.find(subview: "dlscard")!
//        print(test1)
//        let test2 = view.find(subview: IDS.dlscard)!
//        print(test2)
//        let test3 = view.find(subview: 456)!
//        print(test3)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.viewModel.load()
        }
    }
}


struct LoginView: ViewBuilder {

    let viewModel: LoginViewModel

    var body: View {
        ZStackView {
            ImageView(UIImage(named: "vector2"))

            VerticalScrollView {
                VStackView {
                    ContainerView {
                        VStackView {
                            LabelView(viewModel.$status)
                                .alignment(.center)
                                .font(.body)
                                .color(.white)
                                .numberOfLines(0)
                                .hidden(true)
                                .onReceive(viewModel.$status.asObservable().skip(1), handler: { context in
                                    UIView.animate(withDuration: 0.2) {
                                        context.view.isHidden = false
                                    }
                                })

                            LabelView("Login Demo")
                                .alignment(.center)
                                .font(.headline)
                                .color(.white)

                            testView
                                .identifier("TEST")
                        }
                        .accessibilityIdentifier(IDS.logoBlock)
                        .spacing(20)
                    }
                    .padding(20)
                    .backgroundColor(.black)

                    ZStackView {
                        ContainerView()
                            .height(100)
                            .position(.top)
                            .backgroundColor(.black)

                        DynamicContainerView(viewModel.$state) { state in
                            switch state {
                            case .loading:
                                LoadingCardView()
                            case .loaded:
                                LoginCardView(viewModel: viewModel)
                            }
                        }
                        .customConstraints { view in
                            guard let parent = view.superview else { return }
                            view.widthAnchor.constraint(equalToConstant: 412).priority(UILayoutPriority(rawValue: 999)).isActive = true
                            view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
                            parent.leftAnchor.constraint(lessThanOrEqualTo: view.leftAnchor, constant: 8).isActive = true
                            parent.rightAnchor.constraint(greaterThanOrEqualTo: view.rightAnchor, constant: -8).isActive = true
                            parent.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                            parent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
                        }
                    }

                    ContainerView()
                        .height(600)

                    SpacerView()
                }
                .spacing(0)

            }
            .backgroundColor(.clear)
            .bounces(false)
            .onDidScroll { context in
                let y = context.view.contentOffset.y
                if y > 50 {
                    context.viewController?.navigationItem.title = "Login Demo"
                    context.find(IDS.logoBlock)?.alpha = 0
                } else {
                    context.viewController?.navigationItem.title = ""
                    context.find(IDS.logoBlock)?.alpha = 1 - ((y * 2) / 100)
                }
            }
        }
    }

    var testView: some ModifiableView {
        LabelView("Test")
            .color(.white)
    }

    var customConstraints: (_ view: UIView) -> Void {
        { view in
            guard let parent = view.superview else { return }
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                view.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
                view.widthAnchor.constraint(equalToConstant: 428).priority(.defaultHigh),
                parent.leftAnchor.constraint(lessThanOrEqualTo: view.leftAnchor),
                parent.rightAnchor.constraint(greaterThanOrEqualTo: view.rightAnchor),
                parent.topAnchor.constraint(equalTo: view.topAnchor),
                parent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20)
            ])
        }
    }

}

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
        .height(150)
    }
}

struct LoginCardView: ViewBuilder {

    let viewModel: LoginViewModel

    var body: View {
        DLSCardView {
            VStackView {
                LabelView("Welcome")
                    .alignment(.center)
                    .font(.headline)
                    .color(.label)

                ContainerView {
                    LabelView(viewModel.$error.asObservable().compactMap({ $0 }))
                        .alignment(.center)
                        .font(.headline)
                        .color(.white)
                        .numberOfLines(0)
                }
                .backgroundColor(.red)
                .cornerRadius(2)
                .padding(8)
                .hidden(true)
                .onReceive(viewModel.$error.asObservable().skip(1), handler: { context in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        UIView.animate(withDuration: 0.2) {
                            context.view.isHidden = context.value == nil
                        }
                    }
                })

                VStackView {
                    TextField(viewModel.$username)
                        .placeholder("Login ID")
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
        .accessibilityIdentifier(IDS.dlscard) // testing identifiers
    }
}

struct NotYetImplementedCardView: ViewBuilder {
    var body: View {
        DLSCardView {
            VStackView {
                LabelView("Not yet implemented...")
                    .alignment(.center)
                    .font(.headline)
                    .color(.secondaryLabel)
            }
            .padding(16)
        }
        .height(150)
    }
}

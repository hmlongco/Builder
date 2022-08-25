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

fileprivate enum IDS: String {
    case dlscard
    case logoBlock
}

class LoginViewController: UIViewController {

    var viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.embed(LoginView(viewModel: viewModel))
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
                            StatusView(status: viewModel.$status)

                            demoLabel
                                .identifier("LABEL")
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
                                    .height(min: 150)
                            case .loaded:
                                LoginCardView(viewModel: viewModel)
                                    .accessibilityIdentifier(IDS.dlscard) // testing identifiers
                            }
                        }
                        .customConstraints(layout)
                    }

                    ContainerView()
                        .height(600)
                        .onAppearOnce { _ in
                            self.viewModel.load()
                        }

                    SpacerView()
                }
                .spacing(0)

            }
            .backgroundColor(.clear)
            .automaticallyAdjustForKeyboard()
            .hideKeyboardOnBackgroundTap()
            .bounces(false)
            .onDidScroll { context in
                let y = context.view.contentOffset.y
                if y > 50 {
                    context.navigationItem?.title = "Login Demo"
                    context.find(IDS.logoBlock)?.alpha = 0
                } else {
                    context.navigationItem?.title = ""
                    context.find(IDS.logoBlock)?.alpha = 1 - ((y * 2) / 100)
                }
            }
        }
    }

    var demoLabel: some ModifiableView {
        LabelView("Login Demo")
            .alignment(.center)
            .font(.headline)
            .color(.white)
    }

    func layout(_ view: UIView) -> Void {
        guard let parent = view.superview else { return }
        view.widthAnchor.constraint(equalToConstant: 412).priority(UILayoutPriority(rawValue: 999)).isActive = true
        view.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        parent.leftAnchor.constraint(lessThanOrEqualTo: view.leftAnchor, constant: -8).isActive = true
        parent.rightAnchor.constraint(greaterThanOrEqualTo: view.rightAnchor, constant: 8).isActive = true
        parent.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        parent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
    }

}

struct StatusView: ViewBuilder {
    @Variable var status: String?
    var body: View {
        LabelView($status)
            .alignment(.center)
            .font(.body)
            .color(.white)
            .numberOfLines(0)
            .hidden(true)
            .onReceive($status.asObservable().skip(1), handler: { context in
                UIView.animate(withDuration: 0.2) {
                    context.view.isHidden = context.value == nil
                }
            })
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

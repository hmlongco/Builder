//
//  ContactFormViewController.swift
//  Builder
//
//  Created by Michael Long on 12/10/21.
//

import UIKit
import RxSwift

class ContactFormViewController: UIViewController {

    var viewModel = ContactFormViewModel()

    private lazy var dismissible = Dismissible<Void>(self)

    let menuItems = [
        "This is option 1",
        "This is option 2",
        "This is option 3",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contact Form"
        viewModel.configure()
        view.backgroundColor = .secondarySystemBackground
        view.embed(content())
    }

    func content() -> View {
        FABMenuView(menuItems: menuItems) {
            VerticalScrollView {
                VStackView {
                    ErrorSection(viewModel: self.viewModel)

                    NameSection(viewModel: self.viewModel)
                    AddressSection(viewModel: self.viewModel)
                    EmailSection(viewModel: self.viewModel)
                    PhoneSection(viewModel: self.viewModel)
                    LegalSection(viewModel: self.viewModel)

                    ButtonView("Save")
                        .style(StyleButtonFilled())
                        .onTap { [unowned self] context in
                            UIView.animate(withDuration: 0.2, animations: {
                                self.viewModel.validate()
                            }, completion: { _ in
                                if self.viewModel.isValid {
                                    self.dismissible.dismiss()
                                }
                            })
                        }

                    SpacerView()
                }
                .spacing(20)
                .padding(20)
            }
            .automaticallyAdjustForKeyboard()
            .hideKeyboardOnBackgroundTap()
        }
    }

}

private struct ErrorSection: ViewBuilder {
    let viewModel: ContactFormViewModel
    var body: View {
        LabelView(viewModel.$error)
            .backgroundColor(.red)
            .color(.white)
            .font(.callout)
            .padding(16)
            .cornerRadius(16)
            .hidden(bind: viewModel.$error.asObservable().map { ($0 ?? "").isEmpty })
    }
}

private struct NameSection: ViewBuilder {
    let viewModel: ContactFormViewModel
    var body: View {
        IconCardView(icon: "person") {
            VStackView {
                MetaTextField(manager: viewModel, id: .first)
                    .style(StyleStandardMetaTextField())
                    .maxWidth(50)

                MetaTextField(manager: viewModel, id: .last)
                    .style(StyleStandardMetaTextField())
                    .maxWidth(50)
            }
        }
    }
}

private struct AddressSection: ViewBuilder {
    let viewModel: ContactFormViewModel
    var body: View {
        IconCardView(icon: "house") {
            VStackView {
                MetaTextField(manager: viewModel, id: .address1)
                    .style(StyleStandardMetaTextField())
                    .maxWidth(100)

                MetaTextField(manager: viewModel, id: .address2)
                    .style(StyleStandardMetaTextField())
                    .maxWidth(50)

                MetaTextField(manager: viewModel, id: .city)
                    .style(StyleStandardMetaTextField())
                    .maxWidth(50)

                HStackView {
                    MetaTextField(manager: viewModel, id: .state)
                        .style(StyleStandardMetaTextField())
                        .maxWidth(2)

                    MetaTextField(manager: viewModel, id: .zip)
                        .style(StyleStandardMetaTextField())
                        .maxWidth(5)
                }
                .distribution(.fillEqually)
            }
        }
    }
}

private struct EmailSection: ViewBuilder {
    let viewModel: ContactFormViewModel
    var body: View {
        IconCardView(icon: "envelope") {
            VStackView {
                MetaTextField(manager: viewModel, id: .email)
                    .style(StyleStandardMetaTextField())
                    .maxWidth(250)

                MetaTextField(manager: viewModel, id: .alternateEmail)
                    .style(StyleStandardMetaTextField())
                    .maxWidth(250)
            }
        }
    }
}

private struct LegalSection: ViewBuilder {
    let viewModel: ContactFormViewModel
    var body: View {
        IconCardView(icon: "doc.plaintext") {
            HStackView {
                VStackView {
                    LabelView("Agree to Terms")
                        .color(bind: viewModel.termsTextColor)
                    LabelView("Some boilerplate text added to inform you that your information is yours.")
                        .style(StyleLabelFootnote())
                        .contentCompressionResistancePriority(.defaultHigh, for: .horizontal)
                }
                SwitchView(viewModel.variable(for: .agree))
            }
            .padding(top: 6, left: 0, bottom: 0, right: 0)
            .alignment(.top)
        }
    }
}

private struct PhoneSection: ViewBuilder {
    let viewModel: ContactFormViewModel
    var body: View {
        IconCardView(icon: "phone") {
            MetaTextField(manager: viewModel, id: .phone)
                .style(StyleStandardMetaTextField())
                .maxWidth(12)
        }
    }
}

struct IconCardView: ViewBuilder {
    let icon: String
    @ViewResultBuilder let content: () -> ViewConvertable
    var body: View {
        ContainerView {
            ContainerView {
                HStackView {
                    ImageView(UIImage(systemName: icon))
                        .contentMode(.center)
                        .tintColor(.label)
                        .frame(height: 34, width: 20)

                    content()
                }
                .alignment(.top)
                .padding(16)
            }
            .cornerRadius(16)
            .clipsToBounds(true)
        }
        .backgroundColor(.systemBackground)
        .cornerRadius(16)
        .shadow(color: .black, radius: 2, opacity: 0.25, offset: CGSize(width: 0, height: 2))
    }
}


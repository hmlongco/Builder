//
//  MenuViewController.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Builder
import Factory
import RxSwift

class MenuViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = ImageView(named: "Logo-DK")
            .frame(height: 50, width: 50)
            .build()

        navigationItem.titleView = imageView

        view.backgroundColor = .systemBackground
        view.embed(MenuStackView())

//        let vc = ContactFormViewController()
//        navigationController?.pushViewController(vc, animated: false)
    }

}

struct MenuStackView: ViewBuilder {
    var body: View {
        ZStackView {
            ImageView(named: "vector")
            VerticalScrollView {
                VStackView {
                    MenuHeaderView()

                    ForEach(MenuOption.options) { option in
                        MenuOptionView(option: option)
                    }

                    LabelView("Created by Michael Long, 2022")
                        .alignment(.center)
                        .font(.footnote)
                        .color(.secondaryLabel)

                    SpacerView()
                }
                .spacing(15)
                .padding(30)
            }
        }

    }
}

struct MenuHeaderView: ViewBuilder {
    var body: View {
        VStackView {
            LabelView("Builder Demo")
                .font(.title1)
            LabelView("Version 1.0")
                .font(.footnote)
                .color(.secondaryLabel)
        }
        .alignment(.center)
        .spacing(0)
    }
}

struct MenuOptionView: ViewBuilder {
    let option: MenuOption
    var body: View {
        ContainerView {
            VStackView {
                LabelView(option.name)
                    .font(.headline)
                LabelView(option.description)
                    .font(.footnote)
                    .color(.secondaryLabel)
                    .numberOfLines(0)
            }
            .spacing(2)
            .padding(16)
        }
        .backgroundColor(UIColor.systemGroupedBackground.withAlphaComponent(0.5))
        .cornerRadius(10)
        .shadow(color: .black.withAlphaComponent(0.5), radius: 3, offset: CGSize(width: 3, height: 3))
        .onTapGesture { context in
            context.push(option.destination())
        }
    }
}

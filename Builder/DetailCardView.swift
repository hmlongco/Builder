//
//  DetailCardView.swift
//  Builder
//
//  Created by Michael Long on 1/18/21.
//

import UIKit
import Resolver
import RxSwift

struct DetailCardView: UIViewBuilder {

    @Injected var viewModel: DetailViewModel

    init(user: User) {
        viewModel.configure(user)
    }

    func build() -> View {
        ContainerView(
            VStackView {
                VStackView {
                    ImageView(viewModel.thumbnail().asObservable())
                        .cornerRadius(50)
                        .frame(height: 100, width: 100)
                    
                    LabelView(viewModel.fullname)
                        .font(.title1)
                }
                .alignment(.center)
                
                VStackView {
                    NameValueView(name: "Email", value: viewModel.email)
                    if true {
                        NameValueView(name: "Phone1", value: viewModel.phone)
                        NameValueView(name: "Phone2", value: viewModel.phone)
                    }
                }
                .spacing(10)
                
                SpacerView()
            }
            .spacing(15)
            .padding(UIEdgeInsets(padding: 10))
        )
        .backgroundColor(.quaternarySystemFill)
        .cornerRadius(8)
    }

}

struct NameValueView: UIViewBuilder {

    let name: String?
    let value: String?

    func build() -> View {
        HStackView {
            LabelView(name)
                .color(.secondaryLabel)
            SpacerView()
            LabelView(value)
        }
        .spacing(4)
    }

}

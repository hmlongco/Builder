//
//  DetailCardView.swift
//  Builder
//
//  Created by Michael Long on 1/18/21.
//

import UIKit
import Resolver
import RxSwift

struct DetailCardView: ViewBuilder {    

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
                    NameValueView(name: "Address", value: viewModel.street)
                    NameValueView(name: "", value: viewModel.cityStateZip)
                }
                .spacing(2)

                VStackView {
                    NameValueView(name: "Email", value: viewModel.email)
                    NameValueView(name: "Phone1", value: viewModel.phone)
                }
                .spacing(2)

                VStackView {
                    NameValueView(name: "Age", value: viewModel.age)
                }
                .spacing(2)

            }
            .spacing(15)
            .padding(UIEdgeInsets(padding: 20))
        )
        .backgroundColor(.quaternarySystemFill)
        .cornerRadius(16)
    }

}

struct NameValueView: ViewBuilder {

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

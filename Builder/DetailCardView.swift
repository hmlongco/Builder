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
        ContainerView {
            VStackView {
                ZStackView {
                    ImageView(viewModel.photo().asObservable())
                        .contentMode(.scaleAspectFill)
                        .clipsToBounds(true)
                    
                    LabelView(viewModel.fullname)
                        .alignment(.right)
                        .font(.headline)
                        .color(.white)
                        .padding(h: 8, v: 8)
                        .backgroundColor(.black)
                        .alpha(0.7)
                }
                .position(.bottom)
                .height(250)
                
                VStackView {
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
                .padding(20)
            }
        }
        .backgroundColor(.quaternarySystemFill)
        .cornerRadius(16)
        .onAppear { _ in
            print("Appeared!")
        }
        .onDisappear { _ in
            print("Disappeared!")
        }
        .onTapGesture { (context) in
            let view = LabelView("Just an onAppear test")
                .alignment(.center)
            context.push(view, animated: true)
        }

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
                .alignment(.right)
        }
        .spacing(4)
    }

}

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
        DLSCard {
            VStackView {
                DetailPhotoBuilder(photo: viewModel.photo(), name: viewModel.fullname)
                
                VStackView {
                    NameValueBuilder(name: "Address", value: viewModel.street)
                    NameValueBuilder(name: "", value: viewModel.cityStateZip)
                    SpacerView(16)
                    NameValueBuilder(name: "Email", value: viewModel.email)
                    NameValueBuilder(name: "Phone1", value: viewModel.phone)
                    SpacerView(16)
                    NameValueBuilder(name: "Age", value: viewModel.age)
                }
                .spacing(2)
                .padding(20)
            }
        }
        .build() // required on an outermost ViewBuilder to return it as view
    }

}

struct DLSCard: ViewBuilder {
    
    let content: () -> ViewConvertable
    
    init(@ViewResultBuilder _ content: @escaping () -> ViewConvertable) {
        self.content = content
    }
    
    func build() -> View {
        ContainerView {
            ContainerView {
                content()
            }
            .backgroundColor(.systemBackground)
            .cornerRadius(16)
            .border(color: .lightGray)
        }
        .backgroundColor(.systemBackground)
        .cornerRadius(16)
        .shadow(color: .black, radius: 4, opacity: 0.2, offset: CGSize(width: 3, height: 3))
    }
}

struct DetailPhotoBuilder: ViewBuilder {
    
    let photo: Observable<UIImage?>
    let name: String

    func build() -> View {
        ZStackView {
            ImageView(photo)
                .contentMode(.scaleAspectFill)
                .clipsToBounds(true)
            
            LabelView(name)
                .alignment(.right)
                .font(.title2)
                .color(.white)
                .padding(h: 20, v: 8)
                .backgroundColor(.black)
                .alpha(0.7)
        }
        .position(.bottom)
        .height(250)
    }
}

struct NameValueBuilder: ViewBuilder {

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

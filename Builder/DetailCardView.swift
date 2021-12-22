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

    var body: View {
        DLSCardView {
            VStackView {
                DetailPhotoView(photo: viewModel.photo(), name: viewModel.fullname)

                VStackView {
                    NameValueView(name: "Address", value: viewModel.street)
                    NameValueView(name: "", value: viewModel.cityStateZip)
                    SpacerView(8)
                    NameValueView(name: "Email", value: viewModel.email)
                    NameValueView(name: "Phone1", value: viewModel.phone)
                    SpacerView(8)
                    NameValueView(name: "Age", value: viewModel.age)
                }
                .spacing(0)
                .padding(20)
            }
            .onAppear { _ in
                print("DLS Card Appeared")
            }
            .onDisappear { _ in
                print("DLS Card Disappeared")
            }
        }
    }

}

struct DetailPhotoView: ViewBuilder {
    
    let photo: Observable<UIImage?>
    let name: String

    var body: View {
        ZStackView {
            ImageView(photo)
                .contentMode(.scaleAspectFill)
                .clipsToBounds(true)
                .height(300)
            LabelView(name)
                .alignment(.right)
                .font(.title2)
                .color(.white)
                .padding(h: 20, v: 8)
                .backgroundColor(.black)
                .alpha(0.7)
                .position(.bottom)
        }
    }
}

struct NameValueView: ViewBuilder {

    let name: String?
    let value: String?

    var body: View {
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

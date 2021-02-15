//
//  MainCardView.swift
//  Builder
//
//  Created by Michael Long on 1/18/21.
//

import UIKit
import Resolver
import RxSwift

struct MainCardBuilder: UIViewBuilder {

    @Injected var viewModel: MainViewModel

    let user: User

    func build() -> View {
        ContainerView(
            HStackView {
                ImageView(viewModel.thumbnail(forUser: user).asObservable())
                    .cornerRadius(25)
                    .frame(height: 50, width: 50)
                VStackView {
                    LabelView(user.fullname)
                    LabelView(user.email)
                        .font(.footnote)
                        .color(.secondaryLabel)
                    SpacerView()
                }
                .spacing(4)
            }
            .padding(UIEdgeInsets(padding: 10))
        )
        .backgroundColor(.quaternarySystemFill)
        .cornerRadius(8)
    }

}

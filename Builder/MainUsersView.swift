//
//  MainUsersView.swift
//  Builder
//
//  Created by Michael Long on 3/1/21.
//

//
//  MainCardView.swift
//  Builder
//
//  Created by Michael Long on 1/18/21.
//

import UIKit
import Resolver
import RxSwift

struct MainUsersView: UIViewBuilder {

    weak var viewController: UIViewController?
    let users: [User]
    
    func build() -> View {
        return VerticalScrollView {
            VStackView(cards())
            .padding(UIEdgeInsets(padding: 16))
        }
        .backgroundColor(.systemBackground)
    }

    func cards() -> [View] {
        users.map { user in
            MainCardBuilder(user: user)
                .build()
                .onTapGesture {
                    let vc = DetailViewController(user: user)
                    viewController?.navigationController?.pushViewController(vc, animated: true)
                }
        }
    }

}

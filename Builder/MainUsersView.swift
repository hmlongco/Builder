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

struct MainUsersTableView: ViewBuilder {

    let users: [User]
    
    func build() -> View {
        TableView(DynamicItemViewBuilder(items: users) { user in
            TableViewCell {
                MainCardBuilder(user: user)
            }
            .accessoryType(.disclosureIndicator)
            .onSelect { (context) in
                let vc = DetailViewController(user: user)
                context.currentNavigationController?
                    .pushViewController(vc, animated: true)
                return false
            }
        })
    }

}

struct MainUsersStackView: ViewBuilder {

    let users: [User]

    func build() -> View {
        VerticalScrollView {
            VStackView(DynamicItemViewBuilder(items: users) { user in
                MainCardBuilder(user: user)
                    .build()
                    .backgroundColor(.secondarySystemBackground)
                    .cornerRadius(10)
                    .onTapGesture { context in
                        let vc = DetailViewController(user: user)
                        context.currentNavigationController?.pushViewController(vc, animated: true)
                    }
            })
            .padding(.init(h: 16, v: 8))
            .spacing(8)
        }
    }

}

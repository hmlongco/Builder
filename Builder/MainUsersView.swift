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
        TableView(DynamicItemViewBuilder(users) { user in
            TableViewCell {
                MainCardBuilder(user: user)
            }
            .accessoryType(.disclosureIndicator)
            .onSelect { (context) in
                context.push(DetailViewController(user: user))
                return false
            }
        })
    }
    
}

struct MainUsersStackView: ViewBuilder {
    let users: [User]
    func build() -> View {
        VerticalScrollView {
            VStackView(DynamicItemViewBuilder(users) { user in
                MainCardBuilder(user: user)
                    .build()
                    .backgroundColor(.secondarySystemBackground)
                    .cornerRadius(25)
                    .onTapGesture { context in
                        let vc = DetailViewController(user: user)
                        context.currentViewController?.present(vc)
                    }
            })
            .padding(h: 16, v: 8)
            .spacing(16)
        }
    }
}

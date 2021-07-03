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

struct MainUsersView: ViewBuilder {

    let users: [User]
    
    func build() -> View {
        TableView<User>(DynamicViewBuilder(array: users) { user in
            MainCardBuilder(user: user)
        })
        .onSelect { (context, user) in
            let vc = DetailViewController(user: user)
            context.currentNavigationController?.pushViewController(vc, animated: true)
            return false
        }
    }

}

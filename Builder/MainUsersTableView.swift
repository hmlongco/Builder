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
    
    var body: View {
        TableView(DynamicItemViewBuilder(users) { user in
            TableViewCell {
                MainCardView(user: user)
            }
            .accessoryType(.disclosureIndicator)
            .onSelect { (context) in
                context.push(DetailViewController(user: user))
                return false
            }
        })
        .onAppear { _ in
            print("Table View Appeared")
        }
        .onDisappear { _ in
            print("Table View Disappeared")
        }
    }
    
}


struct MainCardView: ViewBuilder {
        
    @Injected var cache: UserImageCache
    
    let user: User
    
    var body: View {
        HStackView {
            ImageView(thumbnail())
                .cornerRadius(25)
                .frame(height: 50, width: 50)
            VStackView {
                LabelView(user.fullname)
                    .font(.preferredFont(forTextStyle: .body))
                LabelView(user.email)
                    .font(.preferredFont(forTextStyle: .footnote))
                    .color(.secondaryLabel)
                SpacerView()
            }
            .spacing(4)
        }
    }

    func thumbnail() -> Observable<UIImage?> {
        return cache.thumbnailOrPlaceholder(forUser: user)
            .asObservable()
            .observe(on: MainScheduler.instance)
    }

}

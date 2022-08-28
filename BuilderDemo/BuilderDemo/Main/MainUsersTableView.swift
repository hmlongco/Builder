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
import Builder
import Factory
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
     }
    
}

struct MainCardView: ViewBuilder {

    @Injected(Container.userImageCache) var cache: UserImageCache
    
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

class UserTableViewCell: BuilderInternalTableViewCell {

    var nameLabel: UILabel?
    var emailLabel: UILabel?

    func configure(_ user: User) {
        if contentView.subviews.isEmpty {
            contentView.embed(body)
        }
        nameLabel?.text = user.fullname
        emailLabel?.text = user.fullname
    }

    var body: View {
        HStackView {
            VStackView {
                LabelView("")
                    .reference(&nameLabel)
                    .font(.preferredFont(forTextStyle: .body))
                LabelView("")
                    .reference(&emailLabel)
                    .font(.preferredFont(forTextStyle: .footnote))
                    .color(.secondaryLabel)
                SpacerView()
            }
            .padding(h: 16, v: 8)
            .spacing(4)
        }
    }

}


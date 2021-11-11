//
//  MainUsersStackView.swift
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


struct MainUsersStackBuilder: ViewBuilder {
    
    let users: [User]
    
    func build() -> View {
        VerticalScrollView {
            VStackView(DynamicItemViewBuilder(users) { user in
                StackCardBuilder(user: user)
                    .build()
                    .backgroundColor(.secondarySystemBackground)
                    .cornerRadius(8)
                    .onTapGesture { context in
                        let vc = DetailViewController(user: user)
                        context.present(vc)
                    }
            })
            .padding(h: 16, v: 8)
            .spacing(16)
        }
    }
}


struct StackCardBuilder: ViewBuilder {
    
    @Injected var cache: UserImageCache
    
    let user: User
    
    func build() -> View {
        HStackView {
            ImageView(thumbnail())
                .frame(height: 60, width: 60)
            VStackView {
                LabelView(user.fullname)
                    .font(.preferredFont(forTextStyle: .body))
                LabelView(user.email)
                    .font(.preferredFont(forTextStyle: .footnote))
                    .color(.secondaryLabel)
                SpacerView()
            }
            .padding(h: 8, v: 8)
            .spacing(4)
        }
    }

    func thumbnail() -> Observable<UIImage?> {
        return cache.thumbnailOrPlaceholder(forUser: user)
            .asObservable()
            .observe(on: MainScheduler.instance)
    }

}

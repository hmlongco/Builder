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


struct MainUsersStackView: ViewBuilder {
    
    let users: [User]
    
    var body: View {
        VerticalScrollView {
            VStackView(DynamicItemViewBuilder(users) { user in
                StackCardView(user: user)
                    .backgroundColor(.secondarySystemBackground)
                    .border(color: .gray)
                    .shadow(color: .black, radius: 3, opacity: 0.2, offset: CGSize(width: 3, height: 3))
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


struct StackCardView: ViewBuilder {
    
    @Injected var cache: UserImageCache
    
    let user: User
    
    var body: View {
        ContainerView {
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
    }

    func thumbnail() -> Observable<UIImage?> {
        return cache.thumbnailOrPlaceholder(forUser: user)
            .asObservable()
            .observe(on: MainScheduler.instance)
    }

}

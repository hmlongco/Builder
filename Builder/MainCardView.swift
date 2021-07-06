//
//  MainCardView.swift
//  Builder
//
//  Created by Michael Long on 1/18/21.
//

import UIKit
import Resolver
import RxSwift

struct MainCardBuilder: ViewBuilder {

    @Injected var cache: UserImageCache

    let user: User

    func build() -> View {
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

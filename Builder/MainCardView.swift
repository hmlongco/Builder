//
//  MainCardView.swift
//  Builder
//
//  Created by Michael Long on 1/18/21.
//

import UIKit
import Resolver
import RxSwift

extension UIFont {
    class func applicationFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        return .preferredFont(forTextStyle: style)
    }
}

struct MainCardBuilder: UIViewBuilder {

    @Injected var cache: UserImageCache

    let user: User

    func build() -> View {
        ContainerView(
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
            .padding(UIEdgeInsets(padding: 10))
        )
        .backgroundColor(.quaternarySystemFill)
        .cornerRadius(8)
    }
    
    func thumbnail() -> Observable<UIImage?> {
        return cache.thumbnailOrPlaceholder(forUser: user)
            .asObservable()
            .observe(on: MainScheduler.instance)
    }

}

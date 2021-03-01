//
//  StandardEmptyPage.swift
//  Builder
//
//  Created by Michael Long on 3/1/21.
//

import UIKit
import Resolver
import RxSwift

struct StandardEmptyPage: UIViewBuilder {

    let message: String

    func build() -> View {
        return VerticalScrollView {
            VStackView {
                LabelView(message)
                    .color(.systemGray)
                SpacerView()
            }
            .padding(UIEdgeInsets(padding: 16))
        }
        .backgroundColor(.systemBackground)
    }
    
}

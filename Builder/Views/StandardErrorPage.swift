//
//  StandardErrorPage.swift
//  Builder
//
//  Created by Michael Long on 3/1/21.
//

import UIKit
import Resolver
import RxSwift

struct StandardErrorPage: ViewBuilder {
    
    let error: String

    func build() -> View {
        return VerticalScrollView {
            VStackView {
                LabelView(error)
                    .color(.red)
                SpacerView()
            }
            .padding(16)
        }
        .backgroundColor(.systemBackground)
    }
    
}

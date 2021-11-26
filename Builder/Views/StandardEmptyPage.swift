//
//  StandardEmptyPage.swift
//  Builder
//
//  Created by Michael Long on 3/1/21.
//

import UIKit
import Resolver
import RxSwift

struct StandardEmptyPage: ViewBuilder {

    let message: String

    var body: View {
        return VerticalScrollView {
            VStackView {
                LabelView(message)
                    .color(.systemGray)
                SpacerView()
            }
            .padding(16)
        }
        .backgroundColor(.systemBackground)
    }
    
}

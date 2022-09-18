//
//  DLSCardView.swift
//  Builder
//
//  Created by Michael Long on 11/22/21.
//

import UIKit
import Builder

struct DLSCardView: ViewBuilder {

    let content: () -> ViewConvertable

    init(@ViewResultBuilder _ content: @escaping () -> ViewConvertable) {
        self.content = content
    }

    var body: View {
        ContainerView {
            ContainerView {
                content()
            }
            .roundedCorners(radius: 16, corners: [.layerMinXMinYCorner])
            .clipsToBounds(true)
        }
        .backgroundColor(.secondarySystemGroupedBackground)
        .roundedCorners(radius: 16, corners: [.layerMinXMinYCorner])
        .shadow(color: .black, radius: 2, opacity: 0.25, offset: CGSize(width: 0, height: 2))
    }
    
}

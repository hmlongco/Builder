//
//  DLSCardView.swift
//  Builder
//
//  Created by Michael Long on 11/22/21.
//

import UIKit

struct DLSCardView: ViewBuilder {

    let content: () -> ViewConvertable

    init(@ViewResultBuilder _ content: @escaping () -> ViewConvertable) {
        self.content = content
    }

    func build() -> View {
        ContainerView {
            ContainerView {
                content()
            }
            .roundedCorners(radius: 16, corners: [.layerMinXMinYCorner])
            .clipsToBounds(true)
        }
        .backgroundColor(.systemBackground)
        .roundedCorners(radius: 16, corners: [.layerMinXMinYCorner])
        .border(color: .lightGray)
        .shadow(color: .black, radius: 4, opacity: 0.2, offset: CGSize(width: 3, height: 3))
    }
}

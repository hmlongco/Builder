//
//  NotYetImplementedCardView.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Builder
import Factory
import RxSwift
import RxCocoa

struct NotYetImplementedCardView: ViewBuilder {
    var body: View {
        DLSCardView {
            VStackView {
                LabelView("Not yet implemented...")
                    .alignment(.center)
                    .font(.headline)
                    .color(.secondaryLabel)
            }
            .padding(16)
        }
        .height(150)
    }
}

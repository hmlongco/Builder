//
//  TextField+Styles.swift
//  Builder
//
//  Created by Michael Long on 9/8/21.
//

import UIKit

struct StyleStandardMetaTextField: BuilderStyle {
    public func apply(to view: MetaTextField.Base) {
        With(view)
            .autocorrectionType(.no)
            .height(34)
            .with {
                $0.bottomLineColor = .standardAccentColor
                $0.selectedBottomLineColor = .standardAccentColor
            }
    }
}


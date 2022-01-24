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
            .set(keyPath: \.clearButtonMode, value: .whileEditing)
            .height(34)
            .tintColor(.red)
            .with {
                $0.bottomLineColor = .standardAccentColor
                $0.selectedBottomLineColor = .standardAccentColor
            }
    }
}


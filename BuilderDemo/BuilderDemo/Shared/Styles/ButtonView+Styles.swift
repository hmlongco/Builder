//
//  ButtonView+Styles.swift
//  Builder
//
//  Created by Michael Long on 9/8/21.
//

import UIKit
import Builder

struct StyleButtonFilled: BuilderStyle {
    public func apply(to view: ButtonView.Base) {
        With(view)
            .cornerRadius(8)
            .color(.white)
            .backgroundColor(.blue, for: .normal)
            .backgroundColor(.blue.darker(), for: .highlighted)
            .backgroundColor(.gray, for: .disabled)
            .padding(10)
    }
}

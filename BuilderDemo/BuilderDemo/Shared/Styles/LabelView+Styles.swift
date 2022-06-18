//
//  LabelView+Styles.swift
//  Builder
//
//  Created by Michael Long on 9/8/21.
//

import UIKit
import Builder

extension UIColor {
    static let standardAccentColor = UIColor(red: 1/255, green: 50/255, blue: 159/255, alpha: 1)
}

struct StyleLabelAccentTitle: BuilderStyle {
    public func apply(to view: LabelView.Base) {
        With(view)
            .font(.footnote)
            .color(.standardAccentColor)
            .with {
                $0.text = $0.text?.uppercased()
            }
    }
}

struct StyleLabelFootnote: BuilderStyle {
    public func apply(to view: LabelView.Base) {
        With(view)
            .font(.footnote)
            .color(.secondaryLabel)
            .numberOfLines(0)
    }
}

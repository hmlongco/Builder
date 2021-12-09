//
//  LabelView+Styles.swift
//  Builder
//
//  Created by Michael Long on 9/8/21.
//

import UIKit

struct StyleLabelAccentTitle: BuilderStyle {
    public func apply(to view: LabelView.Base) {
        ViewModifier(view)
            .font(.footnote)
            .color(UIColor(red: 1/255, green: 50/255, blue: 159/255, alpha: 1))
            .with {
                $0.text = $0.text?.uppercased()
            }
    }
}

struct StyleLabelFootnote: BuilderStyle {
    public func apply(to view: LabelView.Base) {
        ViewModifier(view)
            .font(.footnote)
            .color(.secondaryLabel)
            .numberOfLines(0)
    }
}

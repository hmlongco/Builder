//
//  LabelView+Styles.swift
//  Builder
//
//  Created by Michael Long on 9/8/21.
//

import UIKit

extension LabelView.Style {
    
    static let footnote = LabelView.Style { label in
        label
            .font(.footnote)
            .color(.secondaryLabel)
            .numberOfLines(0)
    }
    
}

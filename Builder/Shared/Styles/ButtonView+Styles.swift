//
//  ButtonView+Styles.swift
//  Builder
//
//  Created by Michael Long on 9/8/21.
//

import UIKit

extension ButtonView.Style {
    
    static let filled = ButtonView.Style { button in
        button
            .cornerRadius(8)
            .color(.white)
            .backgroundColor(.blue, for: .normal)
            .backgroundColor(.blue.darker(), for: .highlighted)
            .backgroundColor(.gray, for: .disabled)
            .padding(10)
    }
    
}

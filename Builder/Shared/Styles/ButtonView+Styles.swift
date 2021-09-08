//
//  ButtonView+Styles.swift
//  Builder
//
//  Created by Michael Long on 9/8/21.
//

import UIKit

extension ButtonView.Style {
    
    static let solid = ButtonView.Style { button in
        button
            .cornerRadius(8)
            .color(.white)
            .buttonBackgroundColor(.blue)
            .padding(10)
    }
    
}

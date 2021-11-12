//
//  Builder+Divider.swift
//  ViewBuilder
//
//  Created by Michael Long on 11/9/21.
//

import UIKit

// Custom builder fot UILabel
public struct DividerView: ModifiableView {
    
    public let modifiableView = Modified(BuilderInternalDividerView(frame: .zero)) {
        let subview = UIView(frame: .zero)
        $0.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13, *) {
            subview.backgroundColor = .secondaryLabel
        } else {
            subview.alpha = 0.4
            subview.backgroundColor = ViewBuilderEnvironment.defaultSeparatorColor ?? UIColor.label
        }
        subview.topAnchor.constraint(equalTo: $0.topAnchor, constant: 4.0).isActive = true
        subview.leftAnchor.constraint(equalTo: $0.leftAnchor).isActive = true
        subview.rightAnchor.constraint(equalTo: $0.rightAnchor).isActive = true
        subview.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        subview.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -4.5).isActive = true
        $0.backgroundColor = .clear
    }
    
    // lifecycle
    public init() {}
    
}

extension ModifiableView where Base: BuilderInternalDividerView {
    
    @discardableResult
    public func color(_ color: UIColor?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.subviews.first?.backgroundColor = color }
    }
    
}

public class BuilderInternalDividerView: UIView {}

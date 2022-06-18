//
//  Builder+Styles.swift
//  Builder
//
//  Created by Michael Long on 11/29/21.
//

import UIKit


public protocol BuilderStyle {
    associatedtype Base: UIView
    func apply(to view: Base)
}

extension ModifiableView {

    @discardableResult
    public func style<Style:BuilderStyle>(_ style: Style) -> ViewModifier<Base> where Style.Base == Base {
        ViewModifier(modifiableView) { style.apply(to: $0) }
    }

    @discardableResult
    public func style<Style:BuilderStyle>(_ style: Style) -> ViewModifier<Base> where Style.Base == UIView {
        ViewModifier(modifiableView) { style.apply(to: $0) }
    }

}

//func test() {
//    LabelView("Some text")
//        .style(StyleLabelAccentTitle())
//    ButtonView("Some text")
//        .style(StyleButtonFilled())
//}

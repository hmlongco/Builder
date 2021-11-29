//
//  Builder+Attributes.swift
//  Builder
//
//  Created by Michael Long on 11/28/21.
//

import UIKit


public class ViewBuilderAttributes {
    var position: UIView.EmbedPosition?
    var insets: UIEdgeInsets?
    var onAppearHandler: ((_ context: ViewBuilderContext<UIView>) -> Void)?
    var onDisappearHandler: ((_ context: ViewBuilderContext<UIView>) -> Void)?
}

extension UIView {

    private static var BuilderAttributesKey: UInt8 = 0

    internal func builderAttributes() -> ViewBuilderAttributes? {
        if let attributes = objc_getAssociatedObject( self, &UIView.BuilderAttributesKey ) as? ViewBuilderAttributes {
            return attributes
        }
        let attributes = ViewBuilderAttributes()
        objc_setAssociatedObject(self, &UIView.BuilderAttributesKey, attributes, .OBJC_ASSOCIATION_RETAIN)
        return attributes
    }

    internal func optionalBuilderAttributes() -> ViewBuilderAttributes? {
        return objc_getAssociatedObject( self, &UIView.BuilderAttributesKey ) as? ViewBuilderAttributes
    }

}

public protocol ViewBuilderEventHandling: UIView {
    // stores into attributes
}

extension ModifiableView where Base: ViewBuilderEventHandling {

    @discardableResult
    public func onAppear(_ handler: @escaping (_ context: ViewBuilderContext<UIView>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.builderAttributes()?.onAppearHandler = handler }
    }

    @discardableResult
    public func onDisappear(_ handler: @escaping (_ context: ViewBuilderContext<UIView>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.builderAttributes()?.onDisappearHandler = handler }
    }

}


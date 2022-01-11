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
    var safeArea: Bool?

    var onAppearHandler: ((_ context: ViewBuilderContext<UIView>) -> Void)?
    var onAppearOnceHandler: ((_ context: ViewBuilderContext<UIView>) -> Void)?
    var onDisappearHandler: ((_ context: ViewBuilderContext<UIView>) -> Void)?

}

// following attributes only apply when view is embedded within a ContainerView, ScrollView, ZStackView, or using when UIView.embed(view)

extension ModifiableView {

    @discardableResult
    public func margins(_ value: CGFloat) -> ViewModifier<Base> {
        margins(insets: UIEdgeInsets(top: value, left: value, bottom: value, right: value))
    }

    @discardableResult
    public func margins(h: CGFloat, v: CGFloat) -> ViewModifier<Base> {
        margins(insets: UIEdgeInsets(top: v, left: h, bottom: v, right: h))
    }

    @discardableResult
    public func margins(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> ViewModifier<Base> {
        margins(insets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }

    @discardableResult
    public func margins(insets: UIEdgeInsets) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.builderAttributes()?.insets = insets }
    }

    @discardableResult
    public func position(_ position: UIView.EmbedPosition) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.builderAttributes()?.position = position
        }
    }

    @discardableResult
    public func safeArea(_ safeArea: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.builderAttributes()?.safeArea = safeArea
        }
    }

}


extension ViewBuilderAttributes {

    public func commonDidMoveToWindow(_ view: UIView) {
        if view.window == nil {
            onDisappearHandler?(ViewBuilderContext(view: view))
        } else if let vc = view.parentViewController, let nc = vc.navigationController, nc.topViewController == vc {
            if let handler = onAppearOnceHandler {
                handler(ViewBuilderContext(view: view))
                onAppearOnceHandler = nil
            }
            onAppearHandler?(ViewBuilderContext(view: view))
        }
    }

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
    public func onAppearOnce(_ handler: @escaping (_ context: ViewBuilderContext<UIView>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.builderAttributes()?.onAppearOnceHandler = handler }
    }

    @discardableResult
    public func onDisappear(_ handler: @escaping (_ context: ViewBuilderContext<UIView>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.builderAttributes()?.onDisappearHandler = handler }
    }

}


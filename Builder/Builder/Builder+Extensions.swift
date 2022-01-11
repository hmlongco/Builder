//
//  Builder+Extensions.swift
//  Builder
//
//  Created by Michael Long on 11/23/21.
//

import UIKit

// Helpers for view conversion
extension UIView {

    public func addSubview(_ view: View) {
        addSubview(view.build())
    }

    public func insertSubview(_ view: View, at index: Int) {
        insertSubview(view.build(), at: index)
    }

}

extension UIView {

    public func empty() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }

    public func reset(_ view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        let existingSubviews = subviews
        addConstrainedSubview(view.build(), position: .fill, padding: padding ?? .zero, safeArea: safeArea)
        existingSubviews.forEach { $0.removeFromSuperview() }
    }

    public func transition(to view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false, delay: Double = 0.2) {
        let newView = view.build()
        if subviews.isEmpty {
            embed(newView, padding: padding, safeArea: safeArea)
            return
        }
        let oldViews = subviews
        if delay > 0 {
            newView.alpha = 0.0
            embed(newView, padding: padding, safeArea: safeArea)
            UIView.animate(withDuration: delay) {
                newView.alpha = 1.0
            } completion: { completed in
                if completed {
                    oldViews.forEach { $0.removeFromSuperview() }
                }
            }
        } else {
            embed(newView, padding: padding, safeArea: safeArea)
            oldViews.forEach { $0.removeFromSuperview() }
        }
    }

    public func transition(to viewController: UIViewController, delay: Double = 0.2) {
        transition(to: ViewControllerHostView(viewController), delay: delay)
    }

    // deprecated version
    @discardableResult
    public func embedModified<V:UIView>(_ view: V, padding: UIEdgeInsets? = nil, safeArea: Bool = false, _ modifier: (_ view: V) -> Void) -> V {
        addConstrainedSubview(view, position: .fill, padding: padding ?? .zero, safeArea: safeArea)
        modifier(view)
        return view
    }
}

extension UIView {

    // goes to top of view chain, then initiates full search of view tree
    public func find<K:RawRepresentable>(_ key: K) -> UIView? where K.RawValue == Int {
        rootview.firstSubview(where: { $0.tag == key.rawValue })
    }
    public func find<K:RawRepresentable>(_ key: K) -> UIView? where K.RawValue == String {
        rootview.firstSubview(where: { $0.accessibilityIdentifier == key.rawValue })
    }

    // searches down the tree looking for identifier
    public func find<K:RawRepresentable>(subview key: K) -> UIView? where K.RawValue == Int {
        firstSubview(where: { $0.tag == key.rawValue })
    }
    public func find<K:RawRepresentable>(subview key: K) -> UIView? where K.RawValue == String {
        firstSubview(where: { $0.accessibilityIdentifier == key.rawValue })
    }

    // searches up the tree looking for identifier in superview path
    public func find<K:RawRepresentable>(superview key: K) -> UIView? where K.RawValue == Int {
        firstSuperview(where: { $0.tag == key.rawValue })
    }
    public func find<K:RawRepresentable>(superview key: K) -> UIView? where K.RawValue == String {
        firstSuperview(where: { $0.accessibilityIdentifier == key.rawValue })
    }

}

extension UIView {

    public func scrollIntoView() {
        guard let scrollview = firstSuperview(where: { $0 is UIScrollView }) as? UIScrollView else {
            return
        }
        let visible = convert(frame, to: scrollview)
        UIViewPropertyAnimator(duration: 0.1, curve: .linear) {
            scrollview.scrollRectToVisible(visible, animated: false)
        }.startAnimation()
    }

}

extension UIView {

    public func firstSubview<Subview:UIView>(ofType subviewType: Subview.Type) -> Subview? {
        return firstSubview(where: { type(of: $0) == subviewType.self }) as? Subview
    }

    public func firstSubview(where predicate: (_ view: UIView) -> Bool) -> UIView? {
        for child in subviews {
            if predicate(child) {
                return child
            } else if let found = child.firstSubview(where: predicate){
                return found
            }
        }
        return nil
    }

    public func firstSuperview<Subview>(ofType subviewType: Subview.Type) -> Subview? {
        return firstSuperview(where: { type(of: $0) == subviewType.self }) as? Subview
    }

    public func firstSuperview(where predicate: (_ view: UIView) -> Bool) -> UIView? {
        if let parent = superview {
            return predicate(parent) ? parent : parent.firstSuperview(where: predicate)
        }
        return nil
    }

    public var rootview: UIView {
        firstSuperview(where: { $0.superview == nil }) ?? self
    }

}

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

extension Int: RawRepresentable {
    public init?(rawValue: Int) {
        self = rawValue
    }
    public var rawValue: Int {
        self
    }
}

extension String: RawRepresentable {
    public init?(rawValue: String) {
        self = rawValue
    }
    public var rawValue: String {
        self
    }
}


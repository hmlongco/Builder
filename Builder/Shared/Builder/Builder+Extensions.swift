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
        addSubview(view.asUIView())
    }

    public func insertSubview(_ view: View, at index: Int) {
        insertSubview(view.asUIView(), at: index)
    }

}

extension UIView {

    public func empty() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }

    public func reset(_ view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        let existingSubviews = subviews
        addSubviewWithConstraints(view.asUIView(), padding, safeArea)
        existingSubviews.forEach { $0.removeFromSuperview() }
    }

    public func transtion(to page: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false, delay: Double = 0.2) {
        let newView = page.asUIView()
        if subviews.isEmpty {
            embed(newView, padding: padding, safeArea: safeArea)
            return
        }
        let oldViews = subviews
        newView.alpha = 0.0
        embed(newView, padding: padding, safeArea: safeArea)
        UIView.animate(withDuration: delay) {
            newView.alpha = 1.0
        } completion: { completed in
            if completed {
                oldViews.forEach { $0.removeFromSuperview() }
            }
        }
    }

    // deprecated version
    @discardableResult
    public func embedModified<V:UIView>(_ view: V, padding: UIEdgeInsets? = nil, safeArea: Bool = false, _ modifier: (_ view: V) -> Void) -> V {
        addSubviewWithConstraints(view, padding, safeArea)
        modifier(view)
        return view
    }
}


extension UIView {

    // goes to top of view chain, then initiates full search of view tree
    public func findViewWithIdentifier(_ identifier: String) -> UIView? {
        return recursiveFind(identifier, keyPath: \.accessibilityIdentifier, in: rootView())
    }

    // searches up the tree looking for identifier in superview path
    public func superviewWithIdentifier(_ identifier: String) -> UIView? {
        return superviewFind(identifier, keyPath: \.accessibilityIdentifier)
    }

    // searches subviews looking for identifier (similar to UIKit viewWithTag)
    public func viewWithIdentifier(_ identifier: String) -> UIView? {
        return recursiveFind(identifier, keyPath: \.accessibilityIdentifier, in: self)
    }

    // goes to top of view chain, then initiates full search of view tree
    public func findViewWithTag(_ tag: Int) -> UIView? {
        return recursiveFind(tag, keyPath: \.tag, in: rootView())
    }

    // searches up the tree looking for tag in superview path
    public func superviewWithTag(_ tag: Int) -> UIView? {
        return superviewFind(tag, keyPath: \.tag)
    }

    internal func rootView() -> UIView {
        var root = self.superview ?? self
        while let view = root.superview { root = view}
        return root
    }

    internal func recursiveFind<T:Equatable>(_ key: T, keyPath: KeyPath<UIView, T>, in view: UIView) -> UIView? {
        if view[keyPath: keyPath] == key {
            return view
        }
        for child in view.subviews {
            if let foundView = recursiveFind(key, keyPath: keyPath, in: child) {
                return foundView
            }
        }
        return nil
    }

    internal func superviewFind<T:Equatable>(_ key: T, keyPath: KeyPath<UIView, T>) -> UIView? {
        var parent: UIView? = self
        while let view = parent {
            if view[keyPath: keyPath] == key {
                return view
            }
            parent = view.superview
        }
        return nil
    }

}

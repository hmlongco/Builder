//
//  Builder+View.swift
//  ViewHelpers
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

extension UIView {

    func embed(_ builder: ViewBuilder, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        self.addSubviewWithConstraints(builder.build(), padding, safeArea)
    }

    func embed(in view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        view.addSubviewWithConstraints(self, padding, safeArea)
    }

    func empty() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func reset(_ builder: ViewBuilder, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        let existingSubviews = subviews
        addSubviewWithConstraints(builder.build(), padding, safeArea)
        existingSubviews.forEach { $0.removeFromSuperview() }
    }

    // deprecated version
    @discardableResult
    func embedModified<V:UIView>(_ view: V, padding: UIEdgeInsets? = nil, safeArea: Bool = false, _ modifier: (_ view: V) -> Void) -> V {
        addSubviewWithConstraints(view, padding, safeArea)
        modifier(view)
        return view
    }
    
    public func addSubviewWithConstraints(_ view: UIView, _ padding: UIEdgeInsets?, _ safeArea: Bool) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        let padding = padding ?? .zero

        if safeArea {
            if #available(iOS 11, *) {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding.top),
                    view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom),
                    view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: padding.left),
                    view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -padding.right)
                ])
                return
            }
        }

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding.bottom),
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding.left),
            view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding.right)
        ])
    }
}

extension UIEdgeInsets {
    public init(padding: CGFloat) {
        self.init(top: padding, left: padding, bottom: padding, right: padding)
    }
    public init(h: CGFloat, v: CGFloat) {
        self.init(top: v, left: h, bottom: v, right: h)
    }
}

extension UIView {

    @discardableResult
    public func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    @discardableResult
    public func backgroundColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }

    @discardableResult
    public func bind(hidden: Observable<Bool>) -> Self {
        hidden
            .subscribe { [weak self] (hidden) in
                self?.isHidden = hidden
            }
            .disposed(by: rxDisposeBag)
        return self
    }

    @discardableResult
    public func contentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }

    @discardableResult
    public func contentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentHuggingPriority(priority, for: axis)
        return self
    }

    @discardableResult
    public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }

    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> Self {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        return self
    }

    @discardableResult
    public func frame(height: CGFloat? = nil, width: CGFloat? = nil) -> Self {
        if let height = height {
            let c = self.heightAnchor.constraint(equalToConstant: height)
            c.priority = UILayoutPriority(rawValue: 999)
            c.isActive = true
        }
        if let width = width {
            let c = self.widthAnchor.constraint(equalToConstant: width)
            c.priority = UILayoutPriority(rawValue: 999)
            c.isActive = true
        }
        return self
    }

    @discardableResult
    public func height(_ height: CGFloat) -> Self {
        let c = self.heightAnchor.constraint(equalToConstant: height)
        c.priority = UILayoutPriority(rawValue: 999)
        c.isActive = true
        return self
    }

    @discardableResult
    public func hidden(_ hidden: Bool) -> Self {
        self.isHidden = hidden
        return self
    }

    @discardableResult
    public func onTapGesture(_ handler: @escaping (_ view: View) -> Void) -> Self {
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        gesture.rx.event
            .asControlEvent()
            .subscribe { (e) in
                handler(self)
            }
            .disposed(by: rxDisposeBag)
        return self
    }

    @discardableResult
    public func translatesAutoresizingMaskIntoConstraints(_ translate: Bool) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = translate
        return self
    }

    @discardableResult
    public func width(_ width: CGFloat) -> Self {
        let c = self.widthAnchor.constraint(equalToConstant: width)
        c.priority = UILayoutPriority(rawValue: 999)
        c.isActive = true
        return self
    }

}

extension UIView {

    private static var RxDisposeBagAttributesKey: UInt8 = 0

    public var rxDisposeBag: DisposeBag {
        if let disposeBag = objc_getAssociatedObject( self, &UIView.RxDisposeBagAttributesKey ) as? DisposeBag {
            return disposeBag
        }
        let disposeBag = DisposeBag()
        objc_setAssociatedObject(self, &UIView.RxDisposeBagAttributesKey, disposeBag, .OBJC_ASSOCIATION_RETAIN)
        return disposeBag
    }

}

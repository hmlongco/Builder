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

    public func transtion(to page: ViewBuilder, position: EmbedPosition = .fill, padding: UIEdgeInsets? = nil, safeArea: Bool = false, delay: Double = 0.2) {
        let newView = page.build()
        if subviews.isEmpty {
            embed(newView, position: position, padding: padding, safeArea: safeArea)
            return
        }
        let oldViews = subviews
        newView.alpha = 0.0
        embed(newView, position: position, padding: padding, safeArea: safeArea)
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
    func embedModified<V:UIView>(_ view: V, padding: UIEdgeInsets? = nil, safeArea: Bool = false, _ modifier: (_ view: V) -> Void) -> V {
        addSubviewWithConstraints(view, padding, safeArea)
        modifier(view)
        return view
    }
}

extension UIView {
    
    public struct TapGestureContext: ViewBuilderContextProvider {
        var view: UIView
        var gesture: UIGestureRecognizer
    }

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
    public func clipsToBounds(_ clips: Bool) -> Self {
        self.clipsToBounds = clips
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
        heightAnchor.constraint(equalToConstant: height)
            .priority(UILayoutPriority(rawValue: 999))
            .activate()
        return self
    }

    @discardableResult
    public func hidden(_ hidden: Bool) -> Self {
        self.isHidden = hidden
        return self
    }

    @discardableResult
    public func onTapGesture(_ handler: @escaping (_ context: TapGestureContext) -> Void) -> Self {
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        let context = TapGestureContext(view: self, gesture: gesture)
        gesture.rx.event
            .asControlEvent()
            .subscribe { (e) in
                handler(context)
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
        widthAnchor.constraint(equalToConstant: width)
            .priority(UILayoutPriority(rawValue: 999))
            .activate()
        return self
    }

}


extension UIView {

    private static var AttributesKey: UInt8 = 0
    
    public func attributes<T>() -> T? {
        if let attributes = objc_getAssociatedObject( self, &UIView.AttributesKey ) as? T {
            return attributes
        }
        return nil
    }
    
    public func attributes(_ attributes: AnyObject) -> Self {
        objc_setAssociatedObject(self, &UIView.AttributesKey, attributes, .OBJC_ASSOCIATION_RETAIN)
        return self
    }
        
}


extension NSObject {

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

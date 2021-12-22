//
//  Builder+Constraints.swift
//  Builder+Constraints
//
//  Created by Michael Long on 9/3/21.
//

import UIKit

extension ModifiableView {

    @discardableResult
    public func contentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.setContentCompressionResistancePriority(priority, for: axis) }
    }

    @discardableResult
    public func contentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.setContentHuggingPriority(priority, for: axis)
        }
    }

    @discardableResult
    public func frame(height: CGFloat? = nil, width: CGFloat? = nil) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            if let height = height {
                $0.heightAnchor
                    .constraint(equalToConstant: height)
                    .priority(UILayoutPriority(rawValue: 999))
                    .identifier("height")
                    .activate()
            }
            if let width = width {
                $0.widthAnchor
                    .constraint(equalToConstant: width)
                    .priority(UILayoutPriority(rawValue: 999))
                    .identifier("width")
                    .activate()
            }
        }
    }

    @discardableResult
    public func height(_ height: CGFloat) -> ViewModifier<Base> {
        self.height(height, priority: UILayoutPriority(999))
    }

    @discardableResult
    public func height(_ height: CGFloat, priority: Float) -> ViewModifier<Base> {
        self.height(height, priority: UILayoutPriority(priority))
    }

    @discardableResult
    public func height(_ height: CGFloat, priority: UILayoutPriority) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.heightAnchor
                .constraint(equalToConstant: height)
                .priority(priority)
                .identifier("height")
                .activate()
        }
    }

    @discardableResult
    public func width(_ width: CGFloat) -> ViewModifier<Base> {
        self.width(width, priority: UILayoutPriority(999))
    }

    @discardableResult
    public func width(_ width: CGFloat, priority: Float) -> ViewModifier<Base> {
        self.width(width, priority: UILayoutPriority(priority))
    }

    @discardableResult
    public func width(_ width: CGFloat, priority: UILayoutPriority) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.widthAnchor
                .constraint(equalToConstant: width)
                .priority(priority)
                .identifier("width")
                .activate()
        }
    }

}

extension UIView {

    public enum EmbedPosition: Int, CaseIterable {
        case fill
        case top
        case topLeft
        case topCenter
        case topRight
        case left
        case center
        case centerLeft
        case centerRight
        case right
        case bottom
        case bottomLeft
        case bottomCenter
        case bottomRight
    }

    public func embed(_ view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        self.addConstrainedSubview(view.build(), position: .fill, padding: padding ?? .zero, safeArea: safeArea)
    }

    public func addConstrainedSubview(_ view: UIView, position: EmbedPosition, padding: UIEdgeInsets, safeArea: Bool = false) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addVerticalConstraints(view, position: position, padding: padding, safeArea: safeArea)
        addHorizontalConstraints(view, position: position, padding: padding, safeArea: safeArea)
    }

    private func addVerticalConstraints(_ view: UIView, position: EmbedPosition, padding: UIEdgeInsets, safeArea: Bool) {
        let guides: UIViewAnchoring = safeArea ? safeAreaLayoutGuide : self

        if [EmbedPosition.center, .centerLeft, .centerRight].contains(position) {
            view.centerYAnchor.constraint(equalTo: guides.centerYAnchor)
                .identifier("centerY")
                .activate()
        } else {
            // top
            if [EmbedPosition.fill, .top, .left, .right, .topLeft, .topCenter, .topRight].contains(position) {
                view.topAnchor.constraint(equalTo: guides.topAnchor, constant: padding.top)
                    .identifier("top")
                    .activate()
            } else {
                view.topAnchor.constraint(lessThanOrEqualTo: guides.topAnchor, constant: padding.top)
                    .priority(.defaultHigh)
                    .identifier("top")
                    .activate()
            }

            // bottom
            if [EmbedPosition.fill, .bottom, .left, .right, .bottomLeft, .bottomCenter, .bottomRight].contains(position) {
                view.bottomAnchor.constraint(equalTo: guides.bottomAnchor, constant: -padding.bottom)
                    .identifier("bottom")
                    .activate()
            } else {
                view.bottomAnchor.constraint(greaterThanOrEqualTo: guides.bottomAnchor, constant: -padding.bottom)
                    .priority(.defaultHigh)
                    .identifier("bottom")
                    .activate()
            }
        }
    }

    private func addHorizontalConstraints(_ view: UIView, position: EmbedPosition, padding: UIEdgeInsets, safeArea: Bool = false) {
        let guides: UIViewAnchoring = safeArea ? safeAreaLayoutGuide : self

        if [EmbedPosition.center, .topCenter, .bottomCenter].contains(position) {
            view.centerXAnchor.constraint(equalTo: guides.centerXAnchor)
                .identifier("centerX")
                .activate()
        } else {
            // left
            if [EmbedPosition.fill, .left, .top, .bottom, .topLeft, .centerLeft, .bottomLeft].contains(position) {
                view.leftAnchor.constraint(equalTo: guides.leftAnchor, constant: padding.left)
                    .identifier("left")
                    .activate()
            } else {
                view.leftAnchor.constraint(lessThanOrEqualTo: guides.leftAnchor, constant: padding.left)
                    .priority(.defaultHigh)
                    .identifier("left")
                    .activate()
            }

            // right
            if [EmbedPosition.fill, .right, .top, .bottom, .topRight, .centerRight, .bottomRight].contains(position) {
                view.rightAnchor.constraint(equalTo: guides.rightAnchor, constant: -padding.right)
                    .identifier("right")
                    .activate()
            } else {
                view.rightAnchor.constraint(greaterThanOrEqualTo: guides.rightAnchor, constant: -padding.right)
                    .priority(.defaultHigh)
                    .identifier("right")
                    .activate()
            }
        }
    }

}

extension ModifiableView {

    @discardableResult
    public func position(_ position: UIView.EmbedPosition) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            $0.builderAttributes()?.position = position
        }
    }

}

private protocol UIViewAnchoring {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UILayoutGuide: UIViewAnchoring {}
extension UIView: UIViewAnchoring {}

extension NSLayoutConstraint {
    @discardableResult
    public func activate(_ isActive: Bool = true) -> Self {
        self.isActive = isActive
        return self
    }
    @discardableResult
    public func identifier(_ identifier: String?) -> Self {
        self.identifier = identifier
        return self
    }
    @discardableResult
    public func priority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
}

//
//  Build+Container.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/28/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

public struct ContainerView: ModifiableView {

    public var modifiableView = Modified(BuilderInternalContainerView(frame: .zero)) {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
    }

    public init(_ view: View? = nil) {
        modifiableView.views = view
    }

    public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        modifiableView.views = builder()
    }

}

extension ModifiableView where Base: BuilderInternalContainerView {

    @discardableResult
    func defaultPosition(_ position: UIView.EmbedPosition) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.position, value: position)
    }

    @discardableResult
    func safeArea(_ safeArea: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.safeArea, value: safeArea)
    }

}

public class BuilderInternalContainerView: UIView, ViewBuilderEventHandling {

    fileprivate var views: ViewConvertable?
    fileprivate var padding: UIEdgeInsets = .zero
    fileprivate var position: EmbedPosition = .fill
    fileprivate var safeArea: Bool = false

    convenience public init(_ view: View?) {
        self.init(frame: .zero)
        self.views = view
    }

    convenience public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        self.init(frame: .zero)
        self.views = builder()
    }

    override public func didMoveToSuperview() {
        views?.asViews().forEach {
            let view = $0.build()
            let attributes = view.optionalBuilderAttributes()
            let position = attributes?.position ?? position
            let padding = attributes?.insets ?? padding
            addConstrainedSubview(view, position: position, padding: padding, safeArea: safeArea)
        }
        super.didMoveToSuperview()
    }

    override public func didMoveToWindow() {
        guard let attributes = optionalBuilderAttributes() else { return }
        // Note didMoveToWindow may be called more than once
        if window == nil {
            attributes.onDisappearHandler?(ViewBuilderContext(view: self))
        } else if let vc = context.viewController, let nc = vc.navigationController, nc.topViewController == vc {
            attributes.onAppearHandler?(ViewBuilderContext(view: self))
        }
    }

}

extension BuilderInternalContainerView: ViewBuilderPaddable {

    public func setPadding(_ padding: UIEdgeInsets) {
        self.padding = padding
    }

}


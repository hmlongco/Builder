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
    
    public var modifiableView = Modified(ViewBuilderInternalContainerView(frame: .zero)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    public init(_ view: View?) {
        modifiableView.views = view
    }

    public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        modifiableView.views = builder()
    }

}

extension ModifiableView where Base: ViewBuilderInternalContainerView {
    
    @discardableResult
    public func onAppear(_ handler: @escaping (_ container: UIView) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.onAppearHandler, value: handler)
    }

    @discardableResult
    public func onDisappear(_ handler: @escaping (_ container: UIView) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.onDisappearHandler, value: handler)
    }

    @discardableResult
    func position(_ position: UIView.EmbedPosition) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.position, value: position)
    }

    @discardableResult
    func safeArea(_ safeArea: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.safeArea, value: safeArea)
    }

}

public class ViewBuilderInternalContainerView: UIView {

    fileprivate var onAppearHandler: ((_ container: UIView) -> Void)?
    fileprivate var onDisappearHandler: ((_ container: UIView) -> Void)?
    
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
        
    override public func didMoveToWindow() {
        // Note didMoveToWindow may be called more than once
        if let views = views {
            views.asViews().forEach { self.addConstrainedSubview($0.asUIView(), position: position, padding: padding, safeArea: safeArea) }
            self.views = nil
        }
        if window == nil {
            onDisappearHandler?(self)
        } else if let vc = context.viewController, let nc = vc.navigationController, nc.topViewController == vc {
            onAppearHandler?(self)
        }
    }

}

extension ViewBuilderInternalContainerView: ViewBuilderPaddable {
    
    public func setPadding(_ padding: UIEdgeInsets) {
        self.padding = padding
    }
    
}

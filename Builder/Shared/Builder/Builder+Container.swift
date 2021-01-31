//
//  Build+Container.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/28/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

class ContainerView: UIView {

    convenience public init(_ view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        self.init(frame: .zero)
        self.embed(view, padding: padding, safeArea: safeArea)
    }

    @discardableResult
    public func reference(_ reference: inout ContainerView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: ContainerView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

final class ZStackView: UIView {

    public init(_ views: [UIView?]) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        views.forEach {
            if let view = $0 {
                self.addSubviewWithConstraints(view, nil, false)
            }
        }
     }

     convenience public init(@UIViewFunctionBuilder _ builder: () -> UIViewConvertable) {
         self.init([builder().asConvertableView()])
     }

     convenience public init(@UIViewFunctionBuilder _ builder: () -> [UIViewConvertable]) {
         self.init(builder().map { $0.asConvertableView() })
     }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func reference(_ reference: inout ZStackView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: ZStackView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

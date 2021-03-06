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

    convenience public init(_ view: View?, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        self.init(frame: .zero)
        if let view = view {
            self.embed(view, padding: padding, safeArea: safeArea)
        }
    }

    convenience public init(padding: UIEdgeInsets? = nil, safeArea: Bool = false, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        self.init(frame: .zero)
        builder().asViews().forEach { self.embed($0, padding: padding, safeArea: safeArea) }
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

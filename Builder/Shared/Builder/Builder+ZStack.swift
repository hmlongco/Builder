//
//  Builder+ZStack.swift
//  Builder
//
//  Created by Michael Long on 1/30/21.
//

import UIKit

final class ZStackView: UIView {

    public init(_ views: [View?]) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        views.forEach {
            if let view = $0 {
                self.addSubviewWithConstraints(view, nil, false)
            }
        }
     }

     convenience public init(@ViewFunctionBuilder _ builder: () -> UIViewConvertable) {
        self.init(builder().asViewConvertable())
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


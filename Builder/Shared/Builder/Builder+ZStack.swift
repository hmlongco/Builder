//
//  Builder+ZStack.swift
//  Builder
//
//  Created by Michael Long on 1/30/21.
//

import UIKit

final class ZStackView: UIView {

    public init(_ convertableViews: [ViewConvertable]) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        convertableViews.asViews().forEach {
            self.addSubviewWithConstraints($0, nil, false)
        }
     }

     convenience public init(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        self.init(builder().asViews())
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


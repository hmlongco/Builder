//
//  Builder+Image.swift
//  ViewHelpers
//
//  Created by Michael Long on 10/29/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

class ImageView: UIImageView {

    public init(configuration: (_ view: UIImageView) -> Void) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        configuration(self)
    }

    public init(_ image: UIImage?) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = image
    }

    public init(_ image: Observable<UIImage>) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bind(image: image)
    }

    public init(_ image: Observable<UIImage?>) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.bind(image: image)
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func bind(image: Observable<UIImage>) -> Self {
        image.subscribe { [weak self] (image) in
            self?.image = image
        }
        .disposed(by: rxDisposeBag)
        return self
    }

    @discardableResult
    public func bind(image: Observable<UIImage?>) -> Self {
        image.subscribe { [weak self] (image) in
            self?.image = image
        }
        .disposed(by: rxDisposeBag)
        return self
    }

    @discardableResult
    public func reference(_ reference: inout ImageView?) -> Self {
        reference = self
        return self
    }

    @discardableResult
    public func with(_ configuration: (_ view: ImageView) -> Void) -> Self {
        configuration(self)
        return self
    }

}

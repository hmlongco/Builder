//
//  Builder+ViewController.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/4/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit

extension UIViewController {

    convenience public init(view: View, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        self.init()
        self.view.backgroundColor = .systemBackground
        self.view.embed(view, padding: padding, safeArea: safeArea)
    }

}

class BuilderViewController: UIViewController {

    private var builder: (() -> UIViewConvertable)?
    private var onViewDidLoadBlock: ((_ viewController: BuilderViewController) -> Void)?
    private var onViewWillAppearBlock: ((_ viewController: BuilderViewController) -> Void)?
    private var onViewDidAppearBlock: ((_ viewController: BuilderViewController) -> Void)?

    public init(@ViewFunctionBuilder _ builder: @escaping () -> UIViewConvertable) {
        self.builder = builder
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view: View = builder?().asViewConvertable().first else {
            fatalError()
        }
        self.view.embed(view)
        self.view.backgroundColor = .systemBackground
        onViewDidLoadBlock?(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppearBlock?(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppearBlock?(self)
    }

}

extension BuilderViewController {

    @discardableResult
    public func onViewDidLoad(block: @escaping (_ viewController: BuilderViewController) -> Void) -> Self {
        self.onViewDidLoadBlock = block
        return self
    }

    @discardableResult
    public func onViewWillAppearBlock(block: @escaping (_ viewController: BuilderViewController) -> Void) -> Self {
        self.onViewWillAppearBlock = block
        return self
    }

    @discardableResult
    public func onViewDidAppear(block: @escaping (_ viewController: BuilderViewController) -> Void) -> Self {
        self.onViewDidAppearBlock = block
        return self
    }

}

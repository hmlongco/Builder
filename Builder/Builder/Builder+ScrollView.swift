//
//  Builder+ScrollView.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/29/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit


public struct ScrollView: ModifiableView {
    
    public var modifiableView = Modified(BuilderInternalScrollView(frame: UIScreen.main.bounds)) {
        $0.delegate = $0
    }

    public init(_ view: View?, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        guard let view = view else { return }
        modifiableView.views = [view]
        modifiableView.padding = padding ?? .zero
        modifiableView.safeArea = safeArea
    }

    public init(padding: UIEdgeInsets? = nil, safeArea: Bool = false, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        modifiableView.views = builder()
        modifiableView.padding = padding ?? .zero
        modifiableView.safeArea = safeArea
    }

}

extension ModifiableView where Base: BuilderInternalScrollView {

    @discardableResult
    public func automaticallyAdjustForKeyboard() -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
                .subscribe(onNext: { [unowned modifiableView] notification in
                    modifiableView.contentInset = .zero
                    modifiableView.scrollIndicatorInsets = modifiableView.contentInset
                })
                .disposed(by: $0.rxDisposeBag)

            NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification, object: nil)
                .subscribe(onNext: { [unowned modifiableView] notification in
                    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

                    let keyboardScreenEndFrame = keyboardValue.cgRectValue
                    let keyboardViewEndFrame = modifiableView.convert(keyboardScreenEndFrame, from: modifiableView.window)
                    let bottom = keyboardViewEndFrame.height - modifiableView.safeAreaInsets.bottom

                    modifiableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
                    modifiableView.scrollIndicatorInsets = modifiableView.contentInset
                })
                .disposed(by: $0.rxDisposeBag)
        }
    }

    @discardableResult
    public func bounces(_ bounce: Bool) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.bounces, value: bounce)
    }

    @discardableResult
    public func onDidScroll(_ handler: @escaping (_ context: ViewBuilderContext<UIScrollView>) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { $0.scrollViewDidScrollHandler = handler }
    }

}

public struct VerticalScrollView: ModifiableView {
    
    public var modifiableView = Modified(BuilderVerticalScrollView(frame: UIScreen.main.bounds)) {
        $0.delegate = $0
    }

    public init(_ view: View?, padding: UIEdgeInsets? = nil, safeArea: Bool = false) {
        guard let view = view else { return }
        modifiableView.embed(view, padding: padding, safeArea: safeArea)
    }

    public init(padding: UIEdgeInsets? = nil, safeArea: Bool = false, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        modifiableView.views = builder()
        modifiableView.padding = padding ?? .zero
        modifiableView.safeArea = safeArea
    }

}

public class BuilderInternalScrollView: UIScrollView, UIScrollViewDelegate {

    public var scrollViewDidScrollHandler: ((_ context: ViewBuilderContext<UIScrollView>) -> Void)?

    fileprivate var views: ViewConvertable?
    fileprivate var padding: UIEdgeInsets = .zero
    fileprivate var position: EmbedPosition = .fill
    fileprivate var safeArea: Bool = false

    @objc public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScrollHandler?(ViewBuilderContext(view: self))
    }

    override public func didMoveToWindow() {
        optionalBuilderAttributes()?.commonDidMoveToWindow(self)
    }

    override public func didMoveToSuperview() {
        embed(views?.asViews() ?? [], padding: padding, safeArea: safeArea)
        super.didMoveToSuperview()
    }

}

public class BuilderVerticalScrollView: BuilderInternalScrollView {

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        subviews.forEach { superview?.widthAnchor.constraint(equalTo: $0.widthAnchor).isActive = true }
    }

}

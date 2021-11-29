//
//  Builder+StackView.swift
//  ViewBuilder
//
//  Created by Michael Long on 11/8/21.
//

import UIKit
import RxSwift


public struct HStackView: ModifiableView {
    
    public let modifiableView = Modified(BuilderInternalUIStackView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = UIStackView.spacingUseSystem
    }
    
    // lifecycle
    public init(spacing: CGFloat = UIStackView.spacingUseSystem, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        builder().asViews().forEach { modifiableView.addArrangedSubview($0) }
    }
    
    public init(_ convertableViews: [ViewConvertable]) {
        convertableViews.asViews().forEach { modifiableView.addArrangedSubview($0) }
     }

    public init(_ builder: AnyIndexableViewBuilder) {
        subscribe(to: builder)
    }
    
}

public struct VStackView: ModifiableView {
    
    public let modifiableView = Modified(BuilderInternalUIStackView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = UIStackView.spacingUseSystem
    }
    
    // lifecycle
    public init(spacing: CGFloat = UIStackView.spacingUseSystem, @ViewResultBuilder _ builder: () -> ViewConvertable) {
        modifiableView.spacing = spacing
        builder().asViews().forEach { modifiableView.addArrangedSubview($0) }
    }
    
    public init(_ convertableViews: [ViewConvertable]) {
        convertableViews.asViews().forEach { modifiableView.addArrangedSubview($0) }
     }

    public init(_ builder: AnyIndexableViewBuilder) {
        subscribe(to: builder)
    }

}

extension ModifiableView where Base: UIStackView {
    
    @discardableResult
    public func alignment(_ alignment: UIStackView.Alignment) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.alignment, value: alignment)
    }
        
    @discardableResult
    public func distribution(_ distribution: UIStackView.Distribution) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.distribution, value: distribution)
    }
    
    @discardableResult
    public func spacing(_ spacing: CGFloat) -> ViewModifier<Base> {
        ViewModifier(modifiableView, keyPath: \.spacing, value: spacing)
    }
    
    @discardableResult
    func subscribe(to builder: AnyIndexableViewBuilder) -> ViewModifier<Base> {
        ViewModifier(modifiableView) {
            // set initial views and...
            modifiableView.reset(to: builder.asViews())
            // subscribe for updates
            builder.updated?
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak modifiableView] views in
                    modifiableView?.reset(to: builder.asViews())
                })
                .disposed(by: $0.rxDisposeBag)
        }
    }

}

// Custom UIStackView modifiers
extension UIStackView: ViewBuilderPaddable {
    
    public func setPadding(_ padding: UIEdgeInsets) {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = padding
    }
    
}

extension UIStackView {
    
    public func addArrangedSubview(_ view: View) {
        addArrangedSubview(view.build())
    }
    
    public func addArrangedSubviews(_ views: View?...) {
        self.addArrangedSubviews(views)
    }

    public func addArrangedSubviews(_ views: [View?]) {
        for view in views {
            if let view = view {
                self.addArrangedSubview(view)
            }
        }
    }

    public func addViews(@ViewResultBuilder _ builder: () -> ViewConvertable) {
        builder().asViews().forEach { self.addArrangedSubview($0.build()) }
    }

    public func reset(to view: View) {
        empty()
        addArrangedSubview(view)
    }

    public func reset(to views: [View]) {
        empty()
        addArrangedSubviews(views)
    }
}

public class BuilderInternalUIStackView: UIStackView, ViewBuilderEventHandling {

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

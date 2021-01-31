//
//  Builder.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/26/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit

public typealias View = UIViewConvertable

@_functionBuilder public struct UIViewFunctionBuilder {

    static public func buildBlock() -> [View?] {
        return []
    }

    static public func buildBlock(_ views: View?...) -> [View] {
        return views
            .compactMap { $0 }
    }

    static public func buildBlock(_ views: [View?]...) -> [View] {
        return views
            .flatMap { $0 }
            .compactMap { $0 }
    }

    static public func buildIf(_ view: View?) -> [View] {
        if let view = view {
            return [view]
        }
        return []
    }

    static public func buildEither(first: View) -> [View] {
        [first]
    }

    static public func buildEither(first: View...) -> [View] {
        first.compactMap { $0 }
    }

    static public func buildEither(second: View) -> [View] {
        [second]
    }

    static public func buildEither(second: View...) -> [View] {
        second.compactMap { $0 }
    }

}

public protocol UIViewConvertable {
    func asConvertableView() -> UIView?
}

extension UIViewConvertable {
    public func asConvertableView() -> UIView? {
        return self as? UIView
    }
    public func asView() -> UIView {
        // swiftlint:disable:next force_cast
        return self.asConvertableView()!
    }
}

extension Array: UIViewConvertable where Element == UIViewConvertable {
    public func asConvertableView() -> UIView? {
        return self.first?.asConvertableView()
    }
}

public protocol UIViewBuilder: View {
    func build() -> View
}

extension UIViewBuilder {
    public func asConvertableView() -> UIView? {
        return build().asConvertableView()
    }
}

struct UIViewBuilderEnvironment {
    static public var defaultButtonFont: UIFont?
    static public var defaultButtonColor: UIColor?
    static public var defaultLabelFont: UIFont?
    static public var defaultLabelColor: UIColor?
    static public var defaultLabelSecondaryColor: UIColor?
    static public var defaultSeparatorColor: UIColor?
}

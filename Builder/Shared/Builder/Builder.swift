//
//  Builder.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/26/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit


public typealias View = UIView



@resultBuilder public struct ViewFunctionBuilder {
    public static func buildBlock() -> [View] {
        []
    }
    public static func buildBlock(_ values: UIViewConvertable...) -> [View] {
        values.flatMap { $0.asViewConvertable() }
    }
    public static func buildIf(_ value: UIViewConvertable?) -> UIViewConvertable {
        value ?? []
    }
    public static func buildEither(first: UIViewConvertable) -> UIViewConvertable {
        first
    }
    public static func buildEither(second: UIViewConvertable) -> UIViewConvertable {
        second
    }
    public static func buildArray(_ components: [[View]]) -> [View] {
        components.flatMap { $0 }
    }
}



public protocol UIViewConvertable {
    func asViewConvertable() -> [View]
}

extension Array: UIViewConvertable where Element == View {
    public func asViewConvertable() -> [View] { self }
}

extension Array where Element == UIViewConvertable {
    public func asViews() -> [View] { self.flatMap { $0.asViewConvertable() } }
}

extension View {
    public struct Empty: UIViewConvertable {
        public func asViewConvertable() -> [View] { [] }
    }
}



public protocol UIViewBuilder: UIViewConvertable {
    func build() -> View
}

extension UIViewBuilder {
    public func asViewConvertable() -> [View] {
        return [build()]
    }
}


extension UIView: UIViewConvertable {
    public func asViewConvertable() -> [View] { [self] }
}



struct UIViewBuilderEnvironment {
    static public var defaultButtonFont: UIFont?
    static public var defaultButtonColor: UIColor?
    static public var defaultLabelFont: UIFont?
    static public var defaultLabelColor: UIColor?
    static public var defaultLabelSecondaryColor: UIColor?
    static public var defaultSeparatorColor: UIColor?
}

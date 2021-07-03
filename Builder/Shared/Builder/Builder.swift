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
    public static func buildBlock(_ values: ViewConvertable...) -> [View] {
        values.flatMap { $0.asViewConvertable() }
    }
    public static func buildIf(_ value: ViewConvertable?) -> ViewConvertable {
        value ?? []
    }
    public static func buildEither(first: ViewConvertable) -> ViewConvertable {
        first
    }
    public static func buildEither(second: ViewConvertable) -> ViewConvertable {
        second
    }
    public static func buildArray(_ components: [[View]]) -> [View] {
        components.flatMap { $0 }
    }
}



public protocol ViewConvertable {
    func asViewConvertable() -> [View]
}

extension Array: ViewConvertable where Element == View {
    public func asViewConvertable() -> [View] { self }
}

extension Array where Element == ViewConvertable {
    public func asViews() -> [View] { self.flatMap { $0.asViewConvertable() } }
}

extension View: ViewConvertable {
    public func asViewConvertable() -> [View] { [self] }
}

//extension View {
//    public struct Empty: ViewConvertable {
//        public func asViewConvertable() -> [View] { [] }
//    }
//}



public protocol ViewBuilder: ViewConvertable {
    func build() -> View
}

extension ViewBuilder {
    public func asViewConvertable() -> [View] {
        return [build()]
    }
}

extension View: ViewBuilder {
    public func build() -> View {
        return self
    }
}



struct ViewBuilderEnvironment {
    static public var defaultButtonFont: UIFont?
    static public var defaultButtonColor: UIColor?
    static public var defaultLabelFont: UIFont?
    static public var defaultLabelColor: UIColor?
    static public var defaultLabelSecondaryColor: UIColor?
    static public var defaultSeparatorColor: UIColor?
}

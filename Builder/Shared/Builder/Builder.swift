//
//  Builder.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/26/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit


public typealias View = UIView


// ViewFunctionBuilder allows SwiftUI-like definitions of UIView trees
@resultBuilder public struct ViewFunctionBuilder {
    public static func buildBlock() -> [View] {
        []
    }
    public static func buildBlock(_ values: ViewConvertable...) -> [View] {
        values.flatMap { $0.asViews() }
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



// Arrays of views are the building blocks of ViewFunctionBuilder
public protocol ViewConvertable {
    func asViews() -> [View]
}

// Allows an array of views to be passed to ViewFunctionBuilder
extension Array: ViewConvertable where Element == View {
    public func asViews() -> [View] { self }
}

// Allows an array of an array of views to be passed to ViewFunctionBuilder
extension Array where Element == ViewConvertable {
    public func asViews() -> [View] { self.flatMap { $0.asViews() } }
}

// Converts a single view to an array of views[s], again for ViewFunctionBuilder
extension View: ViewConvertable {
    public func asViews() -> [View] { [self] }
}



// Allows users to constructs their own view components
public protocol ViewBuilder: ViewConvertable {
    func build() -> View
}

// Allows view builders to coexist with views when passed to view function builders
extension ViewBuilder {
    public func asViews() -> [View] {
        return [build()]
    }
}

// Allows any view to be passed to a function expecting a builder
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

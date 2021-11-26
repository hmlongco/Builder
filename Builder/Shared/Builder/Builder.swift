//
//  Builder.swift
//  ViewBuilder
//
//  Created by Michael Long on 11/8/21.
//

import UIKit



// ViewResultBuilder allows SwiftUI-like definitions of UIView trees
@resultBuilder public struct ViewResultBuilder {
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



// Arrays of views are the building blocks of ViewResultBuilder
public protocol ViewConvertable {
    func asViews() -> [View]
}

// Allows an array of views to be used with ViewResultBuilder
extension Array: ViewConvertable where Element == View {
    public func asViews() -> [View] { self }
}

// Allows an array of an array of views to be used with ViewResultBuilder
extension Array where Element == ViewConvertable {
    public func asViews() -> [View] { self.flatMap { $0.asViews() } }
}

// Allow views to be automatically be ViewConvertable
extension View {
    public func asViews() -> [View] {
        [asUIView()]
    }
}



// Fundamental view object that knows how to convert a "view" to a UIView
public protocol View: ViewConvertable {
    func asUIView() -> UIView
}

// Allows modifications to be made to a given view type
public protocol ModifiableView: View {
    associatedtype Base: UIView
    var modifiableView: Base { get }
}

// Standard "builder" modifiers for all view types
extension ModifiableView {
    public func asBaseView() -> Base {
        modifiableView
    }
    public func asUIView() -> UIView {
        modifiableView
    }
    public func reference(_ view: inout Base?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view = $0 }
    }
    public func with(_ modifier: (_ view: Base) -> Void) -> ViewModifier<Base> {
        ViewModifier(modifiableView, modifier: modifier)
    }
}

// Generic return type for building/chaining view modifiers
public struct ViewModifier<Base:UIView>: ModifiableView {
    public let modifiableView: Base
    public init(_ view: Base) {
        self.modifiableView = view
    }
    public init(_ view: Base, modifier: (_ view: Base) -> Void) {
        self.modifiableView = view
        modifier(view)
    }
    public init<Value>(_ view: Base, keyPath: ReferenceWritableKeyPath<Base, Value>, value: Value) {
        self.modifiableView = view
        self.modifiableView[keyPath: keyPath] = value
    }
}

// Helper function to simplify custom view builder initialization
public func Modified<T:AnyObject>( _ instance: T, modify: (_ instance: T) -> Void) -> T {
    modify(instance)
    return instance
}



// ViewBuilder allows for user-defined custom view configurations
public protocol ViewBuilder: ModifiableView {
    func build() -> View
}

extension ViewBuilder {
    // adapt viewbuilder to enable basic modifications
    public var modifiableView: UIView {
        build().asUIView()
    }
    // allow basic conversion to UIView
    public func asUIView() -> UIView {
        build().asUIView()
    }
}



public struct ViewBuilderEnvironment {
    static public var defaultButtonFont: UIFont?
    static public var defaultButtonColor: UIColor?
    static public var defaultLabelFont: UIFont?
    static public var defaultLabelColor: UIColor?
    static public var defaultLabelSecondaryColor: UIColor?
    static public var defaultSeparatorColor: UIColor?
}

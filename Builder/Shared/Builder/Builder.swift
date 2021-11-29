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



// Fundamental view object that knows how to build a UIView from a given view or view definition
public protocol View: ViewConvertable {
    func build() -> UIView
}

// Allow any view to be automatically be ViewConvertable
extension View {
    public func asViews() -> [View] {
        [build()]
    }
}



// Allows view builder modifications to be made to a given UIView type
public protocol ModifiableView: View {
    associatedtype Base: UIView
    var modifiableView: Base { get }
}

// Standard "builder" modifiers for all view types
extension ModifiableView {
    public func asBaseView() -> Base {
        modifiableView
    }
    public func build() -> UIView {
        modifiableView
    }
    public func reference<V:UIView>(_ view: inout V?) -> ViewModifier<Base> {
        ViewModifier(modifiableView) { view = $0 as? V }
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
    var body: View { get }
}

extension ViewBuilder {
    // adapt viewbuilder to enable basic modifications
    public var modifiableView: UIView {
        body.build()
    }
    // allow basic conversion to UIView
    public func build() -> UIView {
        body.build()
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

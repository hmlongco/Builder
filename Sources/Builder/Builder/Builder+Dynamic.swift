//
//  Builder+ForEach.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/30/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit
import RxSwift

public protocol AnyIndexableViewBuilder: ViewConvertable {
    var count: Int { get }
    var updated: Observable<Void>? { get }
    func view(at index: Int) -> View?
}

public struct StaticViewBuilder: AnyIndexableViewBuilder {

    private var views: [View]

    public init(@ViewResultBuilder _ views: () -> ViewConvertable) {
        self.views = views().asViews()
    }

    public var count: Int { views.count }
    public var updated: Observable<Void>?

    public func view(at index: Int) -> View? {
        guard views.indices.contains(index) else { return nil }
        return views[index]
    }

    public func asViews() -> [View] {
        views
    }

}

public class DynamicItemViewBuilder<Item>: AnyIndexableViewBuilder {

    public var items: [Item] {
        didSet {
            updatePublisher.onNext(())
        }
    }

    public var count: Int { items.count }
    public var updated: Observable<Void>? { updatePublisher }

    private let updatePublisher = PublishSubject<Void>()
    private let builder: (_ item: Item) -> View?

    public init(_ items: [Item]?, builder: @escaping (_ item: Item) -> View?) {
        self.items = items ?? []
        self.builder = builder
    }

    public func item(at index: Int) -> Item? {
        guard items.indices.contains(index) else { return nil }
        return items[index]
    }

    public func view(at index: Int) -> View? {
        guard let item = item(at: index) else { return nil }
        return builder(item)
    }

    public func asViews() -> [View] {
        return items.compactMap { self.builder($0) }
    }

}

public class DynamicObservableViewBuilder<Value>: AnyIndexableViewBuilder {

    public var count: Int { view == nil ? 0 : 1 }
    public var updated: Observable<Void>?

    private var view: View?
    private var disposeBag = DisposeBag()

    public init(_ observable: Observable<Value>, builder: @escaping (_ value: Value) -> View) {
        self.updated = observable
            .do(onNext: { [weak self] value in
                self?.view = builder(value)
            })
            .map { _ in () }
    }

    public func view(at index: Int) -> View? {
        guard index == 0 else { return nil }
        return view
    }

    public func asViews() -> [View] {
        guard let view = view else { return [] }
        return [view]
    }

}

public class DynamicValueViewBuilder<Value>: AnyIndexableViewBuilder {

    public var value: Value {
        didSet {
            updatePublisher.onNext(())
        }
    }

    public var count: Int = 1
    public var updated: Observable<Void>? { updatePublisher }

    private let updatePublisher = PublishSubject<Void>()
    private let builder: (_ value: Value) -> View

    public init(_ value: Value, builder: @escaping (_ value: Value) -> View) {
        self.value = value
        self.builder = builder
    }

    public func view(at index: Int) -> View? {
        guard index == 0 else { return nil }
        return builder(value)
    }

    public func asViews() -> [View] {
        return [builder(value)]
    }

}

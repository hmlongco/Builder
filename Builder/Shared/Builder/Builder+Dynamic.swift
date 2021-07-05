//
//  Builder+ForEach.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/30/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit
import RxSwift



protocol AnyIndexableViewBuilder: ViewConvertable {
    var count: Int { get }
    func view(at index: Int) -> View?
}

extension AnyIndexableViewBuilder {
    var isEmpty: Bool { count == 0 }
}

protocol AnyIndexableDataProvider {
    var count: Int { get }
    func data(at index: Int) -> Any?
}

protocol AnyUpdatableDataProvider {
    var updated: Observable<Any?> { get }
}



struct StaticViewBuilder: AnyIndexableViewBuilder {
    
    private var views: [View]
    
    public init(@ViewResultBuilder  _ views: () -> ViewConvertable) {
        self.views = views().asViews()
    }
    
    var count: Int { views.count }
    
    func view(at index: Int) -> View? {
        guard views.indices.contains(index) else { return nil }
        return views[index]
    }
    
    func asViews() -> [View] {
        views
    }
    
}



class DynamicItemViewBuilder<Item>: AnyIndexableViewBuilder, AnyIndexableDataProvider, AnyUpdatableDataProvider {
    
    var items: [Item] {
        didSet {
            updatePublisher.onNext(self)
        }
    }
    
    private let builder: (_ item: Item) -> ViewBuilder?
    private var updatePublisher = PublishSubject<Any?>()
    
    public init(items: [Item], builder: @escaping (_ item: Item) -> ViewBuilder?) {
        self.items = items
        self.builder = builder
    }
    
    var count: Int { items.count }
    
    var updated: Observable<Any?> { updatePublisher }
    
    func item(at index: Int) -> Item? {
        guard items.indices.contains(index) else { return nil }
        return items[index]
    }
    
    func data(at index: Int) -> Any? {
        item(at: index)
    }
    
    func view(at index: Int) -> View? {
        guard let item = item(at: index) else { return nil }
        return builder(item)?.build()
    }

    public func asViews() -> [View] {
        return items.compactMap { self.builder($0)?.build() }
    }

}











public protocol ViewListBuilder {
    func build() -> [View]
    func onChange(_ changed: @escaping () -> Void)
}

extension ViewListBuilder {
    public func onChange(_ changed: @escaping () -> Void) {}
}


public protocol DynamicViewBuilderType: ViewListBuilder {
    associatedtype Item
    var count: Int { get }
    func item(at index: Int) -> Item?
    func build(at index: Int) -> View?
    func build(_ item: Item?) -> View?
}


class xDynamicViewBuilder<Item>: DynamicViewBuilderType {

    var items: [Item] {
        didSet {
            changed?()
        }
    }

    let builder: (_ item: Item) -> View?
    
    private var changed: (() -> Void)?

    public init(array: [Item], builder: @escaping (_ item: Item) -> View?) {
        self.items = array
        self.builder = builder
    }

    public init(array: [Item], builder: @escaping (_ item: Item) -> ViewBuilder?) {
        self.items = array
        self.builder = { item in builder(item)?.build() }
    }

    var count: Int {
        return items.count
    }

    public func item(at index: Int) -> Item? {
        guard items.indices.contains(index) else { return nil }
        return items[index]
    }

    public func build(at index: Int) -> View? {
        return build(item(at: index))
    }

    public func build(_ item: Item?) -> View? {
        guard let item = item else { return nil }
        return builder(item)
    }

    public func build() -> [View] {
        return items.compactMap { self.build($0) }
    }

    public func onChange(_ changed: @escaping () -> Void) {
        self.changed = changed
    }

}

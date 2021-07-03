//
//  Builder+ForEach.swift
//  ViewBuilder
//
//  Created by Michael Long on 9/30/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import UIKit


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


class DynamicViewBuilder<Item>: DynamicViewBuilderType {

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

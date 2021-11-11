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
    var updated: PublishSubject<Void>? { get }
    func view(at index: Int) -> View?
}

public struct StaticViewBuilder: AnyIndexableViewBuilder {

    private var views: [View]

    public init(@ViewResultBuilder _ views: () -> ViewConvertable) {
        self.views = views().asViews()
    }

    public var count: Int { views.count }
    public var updated: PublishSubject<Void>?

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
            updated?.onNext(())
        }
    }

    public var count: Int { items.count }
    public var updated: PublishSubject<Void>? = PublishSubject()

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

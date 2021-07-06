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
    var updated: Observable<Any?>? { get }
    func view(at index: Int) -> View?
}

extension AnyIndexableViewBuilder {
    var updated: Observable<Any?>? { nil }
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



class DynamicItemViewBuilder<Item>: AnyIndexableViewBuilder {
    
    var items: [Item] {
        didSet {
            updated.onNext(self)
        }
    }
    
    var count: Int { items.count }
    
    var updated = PublishSubject<Any?>()

    private let builder: (_ item: Item) -> ViewBuilder?
    
    public init(items: [Item], builder: @escaping (_ item: Item) -> ViewBuilder?) {
        self.items = items
        self.builder = builder
    }
    
    func item(at index: Int) -> Item? {
        guard items.indices.contains(index) else { return nil }
        return items[index]
    }
    
    func view(at index: Int) -> View? {
        guard let item = item(at: index) else { return nil }
        return builder(item)?.build()
    }

    public func asViews() -> [View] {
        return items.compactMap { self.builder($0)?.build() }
    }

}


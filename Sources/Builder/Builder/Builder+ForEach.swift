//
//  Builder+ForEach.swift
//  ViewBuilder
//
//  Created by Michael Long on 11/7/21.
//

import Foundation

public struct ForEach: ViewConvertable {

    private var views: [View] = []

    public init(_ count: Int, _ builder: (_ index: Int) -> View) {
        for index in 0..<count {
            views.append(builder(index))
        }
    }

    public init<Element>(_ array: [Element], _ builder: (_ element: Element) -> View) {
        views = array.map { builder($0) }
    }

    public func asViews() -> [View] {
        views
    }

}

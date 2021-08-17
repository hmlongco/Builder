//
//  Functions+Extensions.swift
//  Functions+Extensions
//
//  Created by Michael Long on 7/29/21.
//

import Foundation

@discardableResult
@inlinable
public func with<T>(_ value: T, _ configuration: ((_ value: T) -> Void)) -> T {
    configuration(value)
    return value
}

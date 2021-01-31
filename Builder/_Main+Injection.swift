//
//  Main+Injection.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import Foundation
import Resolver

extension Resolver {
    static func registerMain() {
        register { MainViewModel() }.scope(.shared)
    }
}

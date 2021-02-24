//
//  AppDelegate+Injection.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import Foundation
import Resolver

#if MOCK
extension Resolver {
    static var mock = Resolver(parent: main)
}
#endif

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerServices()
        registerMain()
        registerDetails()
        
        #if MOCK
        root = mock
        #endif
    }
}

//
//  Resolver+XCTest.swift
//  BuilderTests
//
//  Created by Michael Long on 2/28/21.
//

import XCTest
import Resolver
import RxSwift
import RxCocoa

@testable import Builder

extension Resolver {
    
    static var test: Resolver!
    
    static func resetUnitTestRegistrations() {
        Resolver.test = Resolver(parent: .mock)
        Resolver.root = .test
        Resolver.test.register { MockUserService() as UserServiceType }
        Resolver.test.register { UserImageCache() } // use our own and not global
        
        MockDelayWrapper.delay = 0.0
    }
}

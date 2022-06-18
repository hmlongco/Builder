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

@testable import BuilderDemo

extension Resolver {
    
    static var test: Resolver!
    
    static func resetUnitTestRegistrations() {
        Resolver.test = Resolver(child: .main)
        Resolver.root = Resolver.test
        Resolver.test.register { MockUserService() as UserServiceType }
        Resolver.test.register { UserImageCache() } // use our own and not global
        
        MockDelayInterceptor.delay = 0.0
    }
}

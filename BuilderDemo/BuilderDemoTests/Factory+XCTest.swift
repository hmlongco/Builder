//
//  Factory+XCTest.swift
//  BuilderTests
//
//  Created by Michael Long on 2/28/21.
//

import XCTest
import Factory
import RxSwift
import RxCocoa

@testable import BuilderDemo

extension Container {
    
    static func resetUnitTestRegistrations() {

        userServiceType.register { MockUserService() }
        userImageCache.register { UserImageCache() } // use our own and not global
        
        MockDelayInterceptor.delay = 0.0
    }
}

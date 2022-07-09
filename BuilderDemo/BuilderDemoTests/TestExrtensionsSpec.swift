//
//  MainViewModelSpec.swift
//  BuilderTests
//
//  Created by Michael Long on 2/22/21.
//

import XCTest
import Factory
import RxSwift
import RxCocoa

@testable import BuilderDemo

class TestExtensionsSpec: XCTestCase {
        
    func testTestFunctions() throws {
        let relay = BehaviorRelay(value: "initial")
        
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.5) {
            relay.accept("updated")
        }

        test("Test relay current value", value: relay.asObservable()) {
            $0 == "initial"
        }
        
        test("Test relay eventual value", value: relay.asObservable()) {
            $0 == "updated"
        }
    }
    
}

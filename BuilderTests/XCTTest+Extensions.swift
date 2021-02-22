//
//  XCTTest+Extensions.swift
//  BuilderTests
//
//  Created by Michael Long on 2/22/21.
//

import Foundation
import XCTest

extension XCTestCase {
    func expect(_ description: String, delay: Double = 5.0, handler: (_ expectation: XCTestExpectation) -> Void) {
        let expectation = XCTestExpectation(description: description)
        handler(expectation)
        wait(for: [expectation], timeout: delay)
    }
}


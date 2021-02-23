//
//  XCTTest+Extensions.swift
//  BuilderTests
//
//  Created by Michael Long on 2/22/21.
//

import Foundation
import XCTest
import RxSwift

extension XCTestCase {
    
    func expect(_ description: String, delay: Double = 5.0, handler: (_ expectation: XCTestExpectation) -> Void) {
        let expectation = XCTestExpectation(description: description)
        handler(expectation)
        wait(for: [expectation], timeout: delay)
    }
    
}

extension XCTestCase {
    
    func test<T>(_ description: String, observable: Observable<T>, delay: Double = 5.0, test: @escaping (_ value: T) -> Bool) {
        let expectation = XCTestExpectation(description: description)
        _ = observable.subscribe(onNext: { (value) in
            if test(value) {
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: delay)
    }

    func test<T>(_ description: String, observable: Single<T>, delay: Double = 5.0, test: @escaping (_ value: T) -> Bool) {
        let expectation = XCTestExpectation(description: description)
        _ = observable.subscribe(onSuccess: { (value) in
            if test(value) {
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: delay)
    }
    
}


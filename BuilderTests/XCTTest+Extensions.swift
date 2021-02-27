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
    
    func test(_ description: String, delay: Double = 5.0, handler: (_ done: @escaping () -> Void) -> Void) {
        let expectation = XCTestExpectation(description: description)
        let done = { () in expectation.fulfill() }
        handler(done)
        wait(for: [expectation], timeout: delay)
    }
    
}

extension XCTestCase {
    
    func test<T>(_ description: String, value o: Observable<T>, delay: Double = 5.0, test: @escaping (_ value: T) -> Bool) {
        let expectation = XCTestExpectation(description: description)
        var success = false
        let disposable = o
            .subscribe(onNext: { (value) in
                guard success == false else { return }
                if test(value) {
                    success = true
                    expectation.fulfill()
                }
            }, onCompleted: {
                if success == false {
                    XCTFail(description)
                    expectation.fulfill()
                }
            })
        wait(for: [expectation], timeout: delay)
        disposable.dispose()
    }
    
    func test<T>(_ description: String, completed o: Observable<T>, delay: Double = 5.0) {
        let expectation = XCTestExpectation(description: description)
        let disposable = o
            .subscribe(onError: { (e) in
                XCTFail(description)
                expectation.fulfill()
            }, onCompleted: {
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: delay)
        disposable.dispose()
    }
    
    func test<T>(_ description: String, error o: Observable<T>, delay: Double = 5.0, test: @escaping (_ error: Error) -> Bool) {
        let expectation = XCTestExpectation(description: description)
        let disposable = o
            .subscribe(onError: { (e) in
                if !test(e) {
                    XCTFail(description)
                }
                expectation.fulfill()
            }, onCompleted: {
                XCTFail(description)
                expectation.fulfill()
            })
        wait(for: [expectation], timeout: delay)
        disposable.dispose()
    }

}

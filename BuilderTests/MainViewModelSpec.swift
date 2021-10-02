//
//  MainViewModelSpec.swift
//  BuilderTests
//
//  Created by Michael Long on 2/22/21.
//

import XCTest
import Resolver
import RxSwift
import RxCocoa

@testable import Builder

class MainViewModelSpec: XCTestCase {
    
    override func setUp() {
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        Resolver.root = .mock
    }
    
    func testInitialState() throws {
        let vm = MainViewModel()

        test("Test initial state", value: vm.state.asObservable()) {
            $0 == .initial
        }
    }

    func testLoadedState() throws {
        let vm = MainViewModel()
        var previousState: MainViewModel.State!
        
        test("Test loaded state") { done in
            _ = vm.state
                .subscribe(onNext: { (state) in
                    switch state {
                    case .initial:
                        XCTAssert(previousState == nil)
                    case .loading:
                        XCTAssert(previousState == .initial)
                    case .loaded(let users):
                        XCTAssert(previousState == .loading)
                        XCTAssert(users.count == 2, "Test user count")
                        XCTAssert(users[0].fullname == "Jonny Quest", "Test user order 0")
                        XCTAssert(users[1].fullname == "Tom Swift", "Test user order 1")
                        done()
                    default:
                        XCTFail("No other state is valid")
                        done()
                    }
                    previousState = state
                })
            vm.load()
        }
    }
    
    func testEmptyState() throws {
        Resolver.test.register { MockEmptyUserService() as UserServiceType }
        
        let vm = MainViewModel()
        var previousState: MainViewModel.State!

        test("Test empty state") { done in
            _ = vm.state
                .subscribe(onNext: { (state) in
                    switch state {
                    case .initial:
                        XCTAssert(previousState == nil)
                    case .loading:
                        XCTAssert(previousState == .initial)
                    case .empty(let message):
                        XCTAssert(message == "No current users found...")
                        done()
                    default:
                        XCTFail("No other state is valid")
                        done()
                    }
                    previousState = state
                })
            vm.load()
        }
    }

    func testErrorState() throws {
        Resolver.test.register { MockErrorUserService() as UserServiceType }
        
        let vm = MainViewModel()
        var previousState: MainViewModel.State!

        test("Test list error state") { done in
            _ = vm.state
                .subscribe(onNext: { (state) in
                    switch state {
                    case .initial:
                        XCTAssert(previousState == nil)
                    case .loading:
                        XCTAssert(previousState == .initial)
                    case .error(let message):
                        XCTAssert(message.contains("unexpected error"))
                        done()
                    default:
                        XCTFail("No other state is valid")
                        done()
                    }
                    previousState = state
                })
            vm.load()
        }
    }
    
}

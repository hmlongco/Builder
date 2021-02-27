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

extension Resolver {
    
    static var test: Resolver!
    
    static func resetUnitTestRegistrations() {
        Resolver.test = Resolver(parent: .mock)
        Resolver.root = .test
        Resolver.test.register { MockUserService() as UserServiceType }
        Resolver.test.register { UserImageCache() } // use our own and not global
    }
}

class MainViewModelSpec: XCTestCase {
    
    override func setUp() {
        Resolver.resetUnitTestRegistrations()
    }
    
    override func tearDown() {
        Resolver.root = .mock
    }
    
    func testInitialState() throws {
        let vm = MainViewModel()

        test("Test initial state", value: vm.state) {
            if case .loading = $0 {
                return true
            }
            return false
        }
    }

    func testLoadedState() throws {
        let vm = MainViewModel()
        var loaded = 0
        
        test("Test loaded state") { done in
            _ = vm.state
                .subscribe(onNext: { (state) in
                    switch state {
                    case .loading:
                        loaded += 1
                        XCTAssert(loaded == 1)
                    case .loaded(let users):
                        XCTAssert(loaded == 1)
                        XCTAssert(users.count == 2)
                        XCTAssert(users[0].fullname == "Jonny Quest")
                        XCTAssert(users[1].fullname == "Tom Swift")
                        done()
                    case .empty(_):
                        XCTFail("Should not be empty")
                        done()
                    case .error(_):
                        XCTFail("Should not error")
                        done()
                    }
                })
            vm.load()
        }
    }
    
    func testThumbnails() throws {
        let vm = MainViewModel()

        let image1 = vm.thumbnail(forUser: User.mockJQ).asObservable()
        test("Test has thumbnail for user", value: image1) {
            $0 == UIImage(named: "User-JQ")
        }

        let image2 = vm.thumbnail(forUser: User.mockTS).asObservable()
        test("Test has placeholder for user", value: image2) {
            $0 == UIImage(named: "User-Unknown")
        }
    }
    
    func testEmptyState() throws {
        Resolver.test.register { MockEmptyUserService() as UserServiceType }

        let vm = MainViewModel()
        vm.load()

        test("Test empty state", value: vm.state) { (state) -> Bool in
            if case .empty(let message) = state {
                return message == "No current users found..."
            }
            return false
        }
    }

    func testListErrorState() throws {
        Resolver.test.register { MockErrorUserService() as UserServiceType }
        
        let vm = MainViewModel()
        vm.load()

        test("Test list error state", value: vm.state) { (state) -> Bool in
            if case .error(let message) = state {
                return message.contains("Builder.APIError")
            }
            return false
        }
    }

    func testImageErrorState() throws {
        Resolver.test.register { MockErrorUserService() as UserServiceType }

        let vm = MainViewModel()
        let image = vm.thumbnail(forUser: User.mockJQ).asObservable()

        test("Test receiving placeholder image on error", value: image) {
            $0 == UIImage(named: "User-Unknown")
        }
    }


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

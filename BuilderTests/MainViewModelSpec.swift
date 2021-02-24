//
//  MainViewModelSpec.swift
//  BuilderTests
//
//  Created by Michael Long on 2/22/21.
//

import XCTest
import Resolver
import RxSwift

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

        test("Test initial state", subscribe: vm.state) {
            if case .loading = $0 {
                return true
            }
            return false
        }
    }

    func testLoadedState() throws {
        let vm = MainViewModel()
        
        test("Test loaded state") { (e) in
            _ = vm.state
                .subscribe(onNext: { (state) in
                    if case .loaded(let users) = state {
                        XCTAssert(users.count == 2)
                        XCTAssert(users[0].fullname == "Jonny Quest")
                        XCTAssert(users[1].fullname == "Tom Swift")
                        e.fulfill()
                    }
                })
            vm.load()
        }
    }
    
    func testThumbnails() throws {
        let vm = MainViewModel()
        vm.load()

        test("Test has thumbnail for user", subscribe: vm.thumbnail(forUser: User.mockJQ)) {
            $0 == UIImage(named: "User-JQ")
        }

        test("Test has placeholder for user", subscribe: vm.thumbnail(forUser: User.mockTS)) {
            $0 == UIImage(named: "User-Unknown")
        }
    }
    
    func testEmptyState() throws {
        Resolver.test.register { MockEmptyUserService() as UserServiceType }

        let vm = MainViewModel()
        vm.load()

        test("Test empty state", subscribe: vm.state) { (state) -> Bool in
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

        test("Test list error state", subscribe: vm.state) { (state) -> Bool in
            if case .error(let message) = state {
                return message.contains("Builder.APIError")
            }
            return false
        }
    }

    func testImageErrorState() throws {
        Resolver.test.register { MockErrorUserService() as UserServiceType }

        let vm = MainViewModel()
 
        let observable = vm.thumbnail(forUser: User.mockJQ)
            .asObservable()
            .materialize()

        test("Test image error state", subscribe: observable) { (event) -> Bool in
            if case .error(let error) = event {
                return error.localizedDescription.contains("Builder.APIError")
            }
            return false
        }
    }

}

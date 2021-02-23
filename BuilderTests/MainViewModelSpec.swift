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

class MainViewModelSpec: XCTestCase {
    
    func testInitialState() throws {
        Resolver.mock.register { MockUserService() as UserServiceType }
        
        let vm = MainViewModel()

        test("Test initial state", observable: vm.state) {
            if case .loading = $0 {
                return true
            }
            return false
        }
    }

    func testLoadedState() throws {
        Resolver.mock.register { MockUserService() as UserServiceType }
        
        let vm = MainViewModel()

        let expectation = XCTestExpectation(description: "Test loaded state")
        
        _ = vm.state
            .subscribe(onNext: { (state) in
                if case .loaded(let users) = state {
                    XCTAssert(users.count == 2)
                    XCTAssert(users[0].fullname == "Jonny Quest")
                    XCTAssert(users[1].fullname == "Tom Swift")
                    expectation.fulfill()
                }
            })
        vm.load()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testThumbnails() throws {
        Resolver.mock.register { MockUserService() as UserServiceType }
        
        let vm = MainViewModel()
        vm.load()

        test("Test has thumbnail for user", observable: vm.thumbnail(forUser: User.mockJQ)) {
            $0 == UIImage(named: "User-JQ")
        }

        test("Test has placeholder for user", observable: vm.thumbnail(forUser: User.mockTS)) {
            $0 == UIImage(named: "User-Unknown")
        }
    }
    
    struct MockEmptyUserService: UserServiceType {
        func list() -> Single<[User]> {
            return .just([])
        }
        func thumbnail(forUser user: User) -> Single<UIImage?> {
            return .just(nil)
        }
    }

    func testEmptyState() throws {
        Resolver.mock.register { MockEmptyUserService() as UserServiceType }
        
        let vm = MainViewModel()
        vm.load()

        test("Test empty state", observable: vm.state) { (state) -> Bool in
            if case .empty(let message) = state {
                return message == "No current users found..."
            }
            return false
        }
    }

    struct MockErrorUserService: UserServiceType {
        func list() -> Single<[User]> {
            return .error(APIError.unexpected)
        }
        func thumbnail(forUser user: User) -> Single<UIImage?> {
            return .just(nil)
        }
    }

    func testErrorState() throws {
        Resolver.mock.register { MockErrorUserService() as UserServiceType }
        
        let vm = MainViewModel()
        vm.load()

        test("Test error state", observable: vm.state) { (state) -> Bool in
            if case .error(let message) = state {
                return message.contains("Builder.APIError")
            }
            return false
        }
    }

}

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

        expect("Test initial state") { e in
            _ = vm.state
                .subscribe(onNext: { (state) in
                    if case .loading = state {
                        XCTAssert(true, "Initial state is .loading")
                    } else {
                        XCTFail("Invalid initial state")
                    }
                    e.fulfill()
                })
        }
    }

    func testLoadedState() throws {
        Resolver.mock.register { MockUserService() as UserServiceType }
        let vm = MainViewModel()
        vm.load()

        expect("Test loaded state") { e in
            _ = vm.state
                .subscribe(onNext: { (state) in
                    if case .loaded(let users) = state {
                        XCTAssert(users.count == 2)
                        XCTAssert(users[0].fullname == "Jonny Quest") // should be in sort order
                        XCTAssert(users[1].fullname == "Tom Swift")
                    } else {
                        XCTFail("Invalid loaded state")
                    }
                    e.fulfill()
                })
        }
    }
    
    func testThumbnails() throws {
        Resolver.mock.register { MockUserService() as UserServiceType }
        let vm = MainViewModel()
        vm.load()

        expect("Test have thumbnail for user") { e in
            _ = vm.thumbnail(forUser: User.mockJQ)
                .subscribe(onSuccess: { (image) in
                    XCTAssert(image == UIImage(named: "User-JQ"))
                    e.fulfill()
                })
        }

        expect("Test have placeholder for user") { e in
            _ = vm.thumbnail(forUser: User.mockTS)
                .subscribe(onSuccess: { (image) in
                    XCTAssert(image == UIImage(named: "User-Unknown"))
                    e.fulfill()
                })
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

        expect("Test empty state") { e in
            _ = vm.state
                .subscribe(onNext: { (state) in
                    if case .empty(let message) = state {
                        XCTAssert(message == "No current users found...")
                    } else {
                        XCTFail("Invalid empty state")
                    }
                    e.fulfill()
                })
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

        expect("Test error state") { e in
            _ = vm.state
                .subscribe(onNext: { (state) in
                    if case .error(let message) = state {
                        XCTAssert(message.contains("Builder.APIError"))
                    } else {
                        XCTFail("Invalid error state")
                    }
                    e.fulfill()
                })
        }
    }

}

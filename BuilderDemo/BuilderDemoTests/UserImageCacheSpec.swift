//
//  UserImageCacheSpec.swift
//  BuilderTests
//
//  Created by Michael Long on 2/22/21.
//

import XCTest
import Factory
import RxSwift
import RxCocoa

@testable import BuilderDemo

class UserImageCacheSpec: XCTestCase {
    
    override func setUp() {
        Container.Registrations.push()
        Container.resetUnitTestRegistrations()
    }

    override func tearDown() {
        Container.Registrations.pop()
    }

    func testImageThumbnails() throws {
        let cache = UserImageCache()

        let image1 = cache.thumbnail(forUser: User.mockJQ).asObservable()
        test("Test has thumbnail for user", value: image1) {
            $0 == UIImage(named: "User-JQ")
        }

        let image2 = cache.thumbnail(forUser: User.mockTS).asObservable()
        test("Test no image for user", value: image2) {
            $0 == nil
        }
    }
    
    func testImagePlaceholders() throws {
        let cache = UserImageCache()

        let image1 = cache.thumbnailOrPlaceholder(forUser: User.mockJQ).asObservable()
        test("Test has thumbnail for user", value: image1) {
            $0 == UIImage(named: "User-JQ")
        }

        let image2 = cache.thumbnailOrPlaceholder(forUser: User.mockTS).asObservable()
        test("Test no image for user", value: image2) {
            $0 == UIImage(named: "User-Unknown")
        }
    }
    
    func testThunbnailError() throws {
        Container.userServiceType.register { MockErrorUserService() as UserServiceType }

        let cache = UserImageCache()
        let image1 = cache.thumbnail(forUser: User.mockJQ).asObservable()

        test("Test receiving nothing on error", error: image1) {
            $0 is APIError
        }

        let image2 = cache.thumbnailOrPlaceholder(forUser: User.mockJQ).asObservable()
        test("Test receiving placeholder image on error", value: image2) {
            $0 == UIImage(named: "User-Unknown")
        }
    }
    
}

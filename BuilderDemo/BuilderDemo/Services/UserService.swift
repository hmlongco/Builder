//
//  UserService.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift
import RxCocoa

protocol UserServiceType {
    func list() -> Single<[User]>
    func thumbnail(forUser user: User) -> Single<UIImage?>
    func photo(forUser user: User) -> Single<UIImage?>
}

struct UserService: UserServiceType {
    
    @Injected var session: ClientSessionManager
    
    init() {
        session.configure { (interceptor: SSOAuthenticationInterceptor) in
            interceptor.token = "F129038AF30912830E8120938"
        }
    }

    func list() -> Single<[User]> {
        session.builder()
            .add(queryItems: [
                URLQueryItem(name: "results", value: "20"),
                URLQueryItem(name: "seed", value: "999"),
                URLQueryItem(name: "nat", value: "us")
            ])
            .with { r in
                print(r)
            }
            .get()
            .decode(type: UserResultType.self, decoder: JSONDecoder())
            .map { $0.results }
            .observe(on: MainScheduler.instance)
    }

    func thumbnail(forUser user: User) -> Single<UIImage?> {
        guard let path = user.picture?.medium else {
            return .just(nil)
        }
        return session.builder(forURL: URL(string: path))
            .get()
            .map { (data: Data) -> UIImage? in UIImage(data: data) }
            .observe(on: MainScheduler.instance)
    }

    func photo(forUser user: User) -> Single<UIImage?> {
        guard let path = user.picture?.large else {
            return .just(nil)
        }
        return session.builder(forURL: URL(string: path))
            .get()
            .map { (data: Data) -> UIImage? in UIImage(data: data) }
            .observe(on: MainScheduler.instance)
    }

}

#if MOCK
struct MockUserService: UserServiceType {

    func list() -> Single<[User]> {
        return .just(User.users)
    }

    func thumbnail(forUser user: User) -> Single<UIImage?> {
        if let name = user.picture?.thumbnail, let image = UIImage(named: name) {
            return .just(image)
        }
        return .just(nil)
    }
    
    func photo(forUser user: User) -> Single<UIImage?> {
        if let name = user.picture?.thumbnail, let image = UIImage(named: name) {
            return .just(image)
        }
        return .just(nil)
    }

}

struct MockEmptyUserService: UserServiceType {
    func list() -> Single<[User]> {
        return .just([])
    }
    func thumbnail(forUser user: User) -> Single<UIImage?> {
        return .just(nil)
    }
    func photo(forUser user: User) -> Single<UIImage?> {
        return .just(nil)
    }
}

struct MockErrorUserService: UserServiceType {
    func list() -> Single<[User]> {
        return .error(APIError.unexpected)
    }
    func thumbnail(forUser user: User) -> Single<UIImage?> {
        return .error(APIError.unexpected)
    }
    func photo(forUser user: User) -> Single<UIImage?> {
        return .error(APIError.unexpected)
    }
}
#endif


struct UserResultType: Codable {
    let results: [User]
}

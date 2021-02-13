//
//  UserService.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift

protocol UserServiceType {
    func list() -> Single<[User]>
    func thumbnail(forUser user: User) -> Single<UIImage?>
}

struct UserService: UserServiceType {
    
    @Injected var session: ClientSessionManagerType

    func list() -> Single<[User]> {
        session.builder()
            .add(path: "/")
            .add(parameters: ["results":20, "nat":"us", "seed":"999"])
            .rx
            .send(.get)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
            .retry(1)
            .map { (results: UserResultType) in results.results }
    }

    func thumbnail(forUser user: User) -> Single<UIImage?> {
        guard let path = user.picture?.thumbnail else {
            return .just(nil)
        }
        return session.builder(forURL: URL(string: path))
            .rx
            .send(.get)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
            .map { (data: Data) -> UIImage? in UIImage(data: data) }
    }

}

#if MOCK
struct MockUserService: UserServiceType {

    func list() -> Single<[User]> {
        return .just([User.mockTS, User.mockJQ])
    }

    func thumbnail(forUser user: User) -> Single<UIImage?> {
        if let name = user.picture?.thumbnail, let image = UIImage(named: name) {
            return .just(image)
        }
        return .just(nil)
    }

}
#endif


private struct UserResultType: Codable {
    let results: [User]
}

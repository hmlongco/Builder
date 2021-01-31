//
//  MainViewModel.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift

class MainViewModel {
    
    @Injected var service: UserServiceType
    @Injected var cache: UserImageCache

    var title = "Builder Demo"
    
    func load() -> Single<[User]> {
        return service.list()
            .map { $0.sorted(by: { ($0.name.last + $0.name.first) < ($1.name.last + $1.name.first) }) }
            .observe(on: MainScheduler.instance)
    }

    func thumbnail(forUser user: User) -> Single<UIImage?> {
        return cache.thumbnail(forUser: user)
            .map { $0 ?? UIImage(named: "User-Unknown") }
            .observe(on: MainScheduler.instance)
    }

}

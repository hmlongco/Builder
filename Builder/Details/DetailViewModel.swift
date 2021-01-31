//
//  DetailViewModel.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift

class DetailViewModel {

    @Injected var cache: UserImageCache

    private var user: User!

    var title : String { user.fullname }

    var fullname: String { user.fullname }
    var email: String { user.email ?? "n/a" }
    var phone: String { user.phone ?? "n/a"}

    func configure(_ user: User) {
        self.user = user
    }

    func thumbnail() -> Single<UIImage?> {
        return cache.thumbnail(forUser: user)
            .map { $0 ?? UIImage(named: "User-Unknown") }
            .observe(on: MainScheduler.instance)
    }

}

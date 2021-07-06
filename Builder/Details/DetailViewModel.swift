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

    var user: User!

    var fullname: String { user.fullname }

    var street: String? {
        guard let loc = user.location, let number = loc.street?.number, let name = loc.street?.name else { return nil }
        return "\(number) \(name)"
    }

    var cityStateZip: String? {
        guard let loc = user.location, let city = loc.city, let state = loc.state, let zip = loc.postcode else { return nil }
        return "\(city) \(state) \(zip)"
    }

    var email: String { user.email ?? "n/a" }
    var phone: String { user.phone ?? "n/a"}

    var age: String {
        guard let age = user.dob?.age else { return "n/a" }
        return "\(age)"
    }

    func configure(_ user: User) {
        self.user = user
    }

    func photo() -> Observable<UIImage?> {
        return cache.photo(forUser: user)
            .map { $0 ?? UIImage(named: "User-Unknown") }
            .observe(on: MainScheduler.instance)
    }

}

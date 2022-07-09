//
//  DetailViewModel.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Builder
import Factory
import RxSwift

class DetailViewModel {

    @Injected(Container.userImageCache) var cache: UserImageCache
    
    @Variable var accepted = false

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
    
    var disposeBag = DisposeBag()
    
    init() {
        $accepted.asObservable()
            .debug()
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
    }

    deinit {
        print("deinit DetailViewModel")
    }

    func configure(_ user: User) {
        self.user = user
    }

    func photo() -> Observable<UIImage?> {
        return cache.photo(forUser: user)
            .map { $0 ?? UIImage(named: "User-Unknown") }
            .observe(on: MainScheduler.instance)
    }
    
#if MOCK
    func configuredViewModel() -> DetailViewModel {
        return with(DetailViewModel()) {
            $0.configure(User.mockJQ)
        }

    }

func makeButton(_ title: String?) -> UIButton {
    with(UIButton()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.text = title
        $0.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        $0.setTitleColor(.red, for: .normal)
    }
}

func makeButton2(_ title: String?) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.text = title
    button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
    button.setTitleColor(.red, for: .normal)
    return button
}

#endif
}

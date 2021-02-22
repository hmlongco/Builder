//
//  MainViewModel.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift
import RxCocoa

class MainViewModel {
    
    @Injected var service: UserServiceType
    @Injected var cache: UserImageCache

    enum State {
        case loading
        case loaded([User])
        case empty(String)
        case error(String)
    }
    
    var state: Observable<State> { internalState.asObservable() }
    var title = "Builder Demo"
    
    private var internalState = BehaviorRelay(value: State.loading)
    private var disposeBag = DisposeBag()
    
    func load() {
        service.list()
            .map { $0.sorted(by: { ($0.name.last + $0.name.first) < ($1.name.last + $1.name.first) }) }
            .subscribe { [weak self] (users) in
                if users.isEmpty {
                    self?.internalState.accept(.empty("No current users found..."))
               } else {
                    self?.internalState.accept(.loaded(users))
                }
            } onFailure: { [weak self] (e) in
                self?.internalState.accept(.error(e.localizedDescription))
            }
            .disposed(by: disposeBag)
    }

    func thumbnail(forUser user: User) -> Single<UIImage?> {
        return cache.thumbnail(forUser: user)
            .map { $0 ?? UIImage(named: "User-Unknown") }
    }

}

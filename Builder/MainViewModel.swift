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
    
    @Injected var images: UserImageCache
    @Injected var service: UserServiceType

    enum State: Equatable {
        case initial
        case loading
        case loaded([User])
        case empty(String)
        case error(String)
     }
    
    var state = BehaviorRelay(value: State.initial)
    var title = "Builder Demo"
    
    private var disposeBag = DisposeBag()
    
    func load() {
        state.accept(.loading)
        service.list()
            .map { $0.sorted(by: { ($0.name.last + $0.name.first) < ($1.name.last + $1.name.first) }) }
            .subscribe { [weak self] (users) in
                if users.isEmpty {
                    self?.state.accept(.empty("No current users found..."))
                } else {
                    self?.state.accept(.loaded(users))
                }
            } onFailure: { [weak self] (e) in
                self?.state.accept(.error(e.localizedDescription))
            }
            .disposed(by: disposeBag)
    }
    
    func refresh() {
        load()
    }

}

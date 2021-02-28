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

    enum State: Equatable {
        case initial
        case loading
        case loaded([User])
        case empty(String)
        case error(String)
     }
    
    var state: Observable<State> { internalState.asObservable() }
    var title = "Builder Demo"
    
    private var users: [User] = []
    private var internalState = BehaviorRelay(value: State.initial)
    private var disposeBag = DisposeBag()
    
    func load() {
        internalState.accept(.loading)
        service.list()
            .map { $0.sorted(by: { ($0.name.last + $0.name.first) < ($1.name.last + $1.name.first) }) }
            .subscribe { [weak self] (users) in
                self?.users = users
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
    
    func refresh() {
        load()
    }

}

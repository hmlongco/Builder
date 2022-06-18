//
//  MainViewModel.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Builder
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
    
    @Variable private(set) var state = State.initial
    
    private var disposeBag = DisposeBag()
    
    func load() {
        state = .loading
        service.list()
            .map { $0.sorted(by: { ($0.name.last + $0.name.first) < ($1.name.last + $1.name.first) }) }
            .subscribe { [weak self] (users) in
                if users.isEmpty {
                    self?.state = .empty("No current users found...")
                } else {
                    self?.state = .loaded(users)
                }
            } onFailure: { [weak self] (e) in
                self?.state = .error(e.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    func refresh() {
        load()
    }

}

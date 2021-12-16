//
//  ViewController.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift

class MainViewController: UIViewController {
    
    @Injected var viewModel: MainViewModel

    var mainView: UIView?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table View Test"
        setupSubscriptions()
    }

    func setupSubscriptions() {
        viewModel.$state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .initial:
                    self.viewModel.load()
                case .loading:
                    self.transition(to: StandardLoadingPage())
                case .loaded(let users):
                    self.transition(to: MainUsersTableView(users: users).reference(&self.mainView))
                case .empty(let message):
                    self.transition(to: StandardEmptyPage(message: message))
                case .error(let error):
                    self.transition(to: StandardErrorPage(error: error))
                }
            })
            .disposed(by: disposeBag)
    }

}

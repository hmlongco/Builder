//
//  ViewController.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift

class MainStackViewController: UIViewController {
    
    @Injected var viewModel: MainViewModel

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack View Test"
        view.backgroundColor = .systemBackground
        setupSubscriptions()
    }

    func setupSubscriptions() {
        viewModel.state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (state) in
                guard let self = self else { return }
                switch state {
                case .initial:
                    self.viewModel.load()
                case .loading:
                    self.transtion(to: StandardLoadingPage())
                case .loaded(let users):
                    self.transtion(to: MainUsersStackView(users: users))
                case .empty(let message):
                    self.transtion(to: StandardEmptyPage(message: message))
                case .error(let error):
                    self.transtion(to: StandardErrorPage(error: error))
                }
            })
            .disposed(by: disposeBag)
    }

}

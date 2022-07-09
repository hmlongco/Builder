//
//  ViewController.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Builder
import Factory
import RxSwift

class MainStackViewController: UIViewController {
    
    @Injected(Container.mainViewModel) var viewModel: MainViewModel

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack View Test"
        view.backgroundColor = .systemBackground
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
                    self.transition(to: MainUsersStackView(users: users))
                case .empty(let message):
                    self.transition(to: StandardEmptyPage(message: message))
                case .error(let error):
                    self.transition(to: StandardErrorPage(error: error))
                }
            })
            .disposed(by: disposeBag)
    }

}

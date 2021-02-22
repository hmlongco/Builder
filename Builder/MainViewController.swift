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

    weak var stackView: VStackView?

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.embed(mainContentView())
        setupSubscriptions()
        viewModel.load()
    }

    func mainContentView() -> View {
        return VerticalScrollView {
            VStackView {
            }
            .padding(UIEdgeInsets(padding: 20))
            .reference(&stackView)
        }
        .backgroundColor(.systemBackground)
    }

    func setupSubscriptions() {
        viewModel.state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (state) in
                switch state {
                case .loading:
                    self?.displayLoadingView()
                case .loaded(let users):
                    self?.displayUsers(users)
                case .empty(let message):
                    self?.displayEmptyView(message)
                case .error(let error):
                    self?.displayErrorView(error)
                }
            })
            .disposed(by: disposeBag)
    }

    func displayLoadingView() {
        let view = UIActivityIndicatorView()
        view.color = .systemGray
        view.startAnimating()
        stackView?.reset(to: view)
    }

    func displayUsers(_ users: [User]) {
        stackView?.reset()
        users.forEach { user in
            self.stackView?.addArrangedSubview(self.card(forUser: user))
        }
    }

    func card(forUser user: User) -> View {
        MainCardBuilder(user: user)
            .build() // convert to view so we can add a tap gesture to it
            .onTapGesture { [weak self] in
                let vc = DetailViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
    }

    func displayEmptyView(_ message: String) {
        let view = LabelView(message)
            .color(.systemGray)
        stackView?.reset(to: view)
    }

    func displayErrorView(_ error: String) {
        let view = LabelView(error)
            .color(.red)
        stackView?.reset(to: view)
    }

}

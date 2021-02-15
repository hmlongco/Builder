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
    }

    func mainContentView() -> View {
        return VerticalScrollView {
            VStackView {
                self.loadingView()
            }
            .padding(UIEdgeInsets(padding: 20))
            .reference(&stackView)
        }
        .backgroundColor(.systemBackground)
    }

    func setupSubscriptions() {
        viewModel.load()
            .subscribe(onSuccess: { (users) in
                self.displayUsers(users)
            })
            .disposed(by: disposeBag)
    }

    func displayUsers(_ users: [User]) {
        stackView?.reset()
        if users.isEmpty {
            stackView?.addArrangedSubview(emptyView())
        } else {
            users.forEach { user in
                self.stackView?.addArrangedSubview(self.card(forUser: user))
            }
        }
    }

    func card(forUser user: User) -> View {
        MainCardBuilder(user: user)
            .build()
            .onTapGesture { [weak self] in
                let vc = DetailViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
    }

    func loadingView() -> View {
        let view = UIActivityIndicatorView()
        view.color = .systemGray
        view.startAnimating()
        return view
    }

    func emptyView() -> View {
        LabelView("No test users found...")
            .color(.systemGray)
    }

}

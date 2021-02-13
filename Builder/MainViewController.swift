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

    lazy var userViewBuilder = DynamicViewBuilder<User>(array: []) { [weak self] user in
        MainCardView(user: user).build()
            .onTapGesture {
                let vc = DetailViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
    }

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
                VStackView(userViewBuilder)
                    .padding(UIEdgeInsets(padding: 20))
                    .reference(&stackView)
            }
            .backgroundColor(.systemBackground)
    }

    func setupSubscriptions() {
        viewModel.load()
            .subscribe(onSuccess: { (users) in
                self.userViewBuilder.items = users
            })
            .disposed(by: disposeBag)
    }

}

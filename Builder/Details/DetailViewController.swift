//
//  ViewController.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift

class DetailViewController: UIViewController {

    @Injected var viewModel: DetailViewModel

    convenience init(user: User) {
        self.init()
        viewModel.configure(user)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.fullname
        view.embed(mainContentView())
        view.backgroundColor = .systemBackground
    }

    func mainContentView() -> View {
        return VerticalScrollView {
            VStackView {
                DetailCardView(user: viewModel.user)
                SpacerView()
            }
            .padding(UIEdgeInsets(padding: 20))
        }
    }

}

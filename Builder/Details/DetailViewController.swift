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
    
    lazy var dismissible = Dismissible<Void>(self)

    convenience init(user: User) {
        self.init()
        viewModel.configure(user)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.fullname
        view.embed(contentView())
        view.backgroundColor = .systemBackground
    }

    func contentView() -> View {
        return VerticalScrollView {
            VStackView {
                DetailCardView(user: viewModel.user)
                SpacerView()
                ButtonView("Dismiss")
                    .onTap { [weak self] _ in
                        self?.dismissible.dismiss()
                    }
                    .with {
                        $0.accessibilityLabel = "fred"
                    }
            }
            .padding(20)
        }
    }

}

//class TestContainerViewController: UIViewController {
//
//    private var user: User!
//
//    convenience init(user: User) {
//        self.init()
//        self.user = user
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.embed(ContainerView(DetailViewController(user: user)))
//    }
//
//}


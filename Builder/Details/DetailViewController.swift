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
    
    deinit {
        print("deinit DetailViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.fullname
        view.embed(contentView())
        view.backgroundColor = .systemBackground
    }

    func contentView() -> View {
        VerticalScrollView {
            VStackView {
                DetailCardView(user: viewModel.user)
                
                ButtonView("Dismiss")
                    .style(.filled)
                    .onTap { [dismissible] _ in
                        dismissible.dismiss()
                    }

                LabelView("Inforamtion presented above is not repesentative of any person, living, dead, undead, or fictional.")
                    .style(.footnote)
                
                SpacerView()
            }
            .padding(20)
            .spacing(20)
        }
    }

}

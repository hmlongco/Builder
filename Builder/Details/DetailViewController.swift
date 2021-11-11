//
//  ViewController.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import UIKit
import Resolver
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {

    @Injected var viewModel: DetailViewModel
    
    lazy var dismissible = Dismissible<Void>(self)
        
    @Variable var testSwtichValue = false

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
        ContainerView {
            VerticalScrollView {
                VStackView {
                    DetailCardBuilder(user: viewModel.user)
                    
                    HStackView {
                        LabelView("Accept Terms")
                        SpacerView()
                        SwitchView(viewModel.$accepted)
                            .onTintColor(.blue)
    //                        .onChange { [weak self] value in
    //                            self?.testSwtichValue = value
    //                        }
                    }
                    
                    ButtonView("Dismiss")
                        .enabled(bind: viewModel.$accepted)
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
        .backgroundColor(.quaternarySystemFill)
    }

}

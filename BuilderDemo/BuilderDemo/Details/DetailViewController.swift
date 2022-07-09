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
import RxCocoa

class DetailViewController: UIViewController {

    @Injected(Container.detailViewModel) var viewModel: DetailViewModel
    
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
        view.embed(contents())
        view.backgroundColor = .systemBackground
    }

    func contents() -> View {
        VerticalScrollView {
            VStackView {
                DetailCardView(user: viewModel.user)

                HStackView {
                    LabelView("Accept Terms")
                    SpacerView()
                    SwitchView(viewModel.$accepted)
                        .onTintColor(.blue)
                }

                ButtonView("Submit")
                    .enabled(bind: viewModel.$accepted)
                    .style(StyleButtonFilled())
                    .onTap { [weak dismissible] _ in
                        dismissible?.dismiss()
                    }

                LabelView("Inforamtion presented above is not repesentative of any person, living, dead, undead, or fictional.")
                    .style(StyleLabelFootnote())

                SpacerView()
            }
            .padding(20)
            .spacing(20)
            .onReceive(viewModel.$accepted) { context in
                context.view.accessibilityLabel = context.value ? "Terms accepted." : "Terms Not yet accepted."
            }
        }
        .backgroundColor(.quaternarySystemFill)
    }

}

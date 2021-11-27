//
//  MenuViewController.swift
//  Builder
//
//  Created by Michael Long on 11/11/21.
//

import UIKit
import Resolver
import RxSwift

extension Resolver {
    static var context: Resolver!
}

class MenuViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ViewBuilder Demo"
        view.backgroundColor = .systemBackground
        view.embed(MenuTableView())
    }

}

struct MenuTableView: ViewBuilder {

    struct Option {
        let name: String
        let description: String
        let destination: () -> UIViewController
    }

    let options: [Option] = [
        Option(name: "Login View Test", description: "A basic login field.") {
            LoginViewController()
        },
        Option(name: "Table View Test", description: "A basic master/detail table view with user data pulled from an API.") {
            MainViewController()
        },
        Option(name: "Stack View Test", description: "A basic master/detail dynamic stack view with user data pulled from an API.") {
            MainStackViewController()
        },
        Option(name: "Test Views", description: "A basic view that tests many elements of ViewBuilder.") {
            TestViewController()
        }
    ]

    var body: View {
        TableView(StaticViewBuilder {
            ForEach(options) {
                MenuTableViewCell(option: $0)
            }
        })
    }

}

struct MenuTableViewCell: ViewBuilder {

    let option: MenuTableView.Option

    var body: View {
        TableViewCell {
            VStackView {
                LabelView(option.name)
                    .font(.headline)
                LabelView(option.description)
                    .font(.footnote)
                    .color(.secondaryLabel)
                    .numberOfLines(0)
            }
            .spacing(2)
        }
        .accessoryType(.disclosureIndicator)
        .onSelect { (context) in
            context.push(option.destination())
            return false
        }
    }

}

struct MenuTableViewOLD: ViewBuilder {

    var body: View {
        TableView(StaticViewBuilder {
            MenuTableViewCellOLD(name: "Login View Test", description: "A basic login field.") {
                LoginViewController()
            }
            MenuTableViewCellOLD(name: "Table View Test", description: "A basic master/detail table view with user data pulled from an API.") {
                MainViewController()
            }
            MenuTableViewCellOLD(name: "Stack View Test", description: "A basic master/detail dynamic stack view with user data pulled from an API.") {
                MainStackViewController()
            }
            MenuTableViewCellOLD(name: "Test Views", description: "A basic view that tests many elements of ViewBuilder.") {
                TestViewController()
            }
        })
    }

}


struct MenuTableViewCellOLD: ViewBuilder {

    let name: String
    let description: String
    let destination: () -> UIViewController

    var body: View {
        TableViewCell {
            VStackView {
                LabelView(name)
                    .font(.headline)
                LabelView(description)
                    .font(.footnote)
                    .color(.secondaryLabel)
                    .numberOfLines(0)
            }
            .spacing(2)
        }
        .accessoryType(.disclosureIndicator)
        .onSelect { (context) in
            context.push(destination())
            return false
        }
    }

}

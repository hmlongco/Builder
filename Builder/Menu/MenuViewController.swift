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
    
    var body: View {
        TableView(StaticViewBuilder {
            MenuTableViewCell(name: "Login View Test", description: "A basic login field.") {
                LoginViewController()
            }
            MenuTableViewCell(name: "Table View Test", description: "A basic master/detail table view with user data pulled from an API.") {
                MainViewController()
            }
            MenuTableViewCell(name: "Stack View Test", description: "A basic master/detail dynamic stack view with user data pulled from an API.") {
                MainStackViewController()
            }
            MenuTableViewCell(name: "Test Views", description: "A basic view that tests many elements of ViewBuilder.") {
                TestViewController()
            }
        })
    }
    
}

struct StandardMenuTableViewCell: ViewBuilder {
    
    let name: String
    let description: String
    let destination: () -> UIViewController
    
    var body: View {
        TableViewCell(title: name, subtitle: description)
            .accessoryType(.disclosureIndicator)
            .onSelect { (context) in
                context.push(destination())
                return false
            }
    }
    
}

struct MenuTableViewCell: ViewBuilder {
    
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

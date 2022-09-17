//
//  MenuOption.swift
//  BuilderDemo
//
//  Created by Michael Long on 9/17/22.
//

import UIKit

struct MenuOption {
    let name: String
    let description: String
    let destination: () -> UIViewController
}

extension MenuOption {
    static let options: [MenuOption] = [
        MenuOption(name: "Login View Test", description: "A basic username/password login screen.") {
            LoginViewController()
        },
        MenuOption(name: "Contact Form Test", description: "A basic contact form screen with a few twists.") {
            ContactFormViewController()
        },
        MenuOption(name: "Table View Test", description: "A basic master/detail table view with user data pulled from an API.") {
            MainViewController()
        },
        MenuOption(name: "Stack View Test", description: "A basic master/detail dynamic stack view with user data pulled from an API.") {
            MainStackViewController()
        },
        MenuOption(name: "Table View Menu Options", description: "An alternative table view that displays our menu options.") {
            MenuTableViewController()
        },
        MenuOption(name: "Tab Bar Test View", description: "A basic view that tests a new tab bar layour.") {
            CustomTabBarViewController()
        },
        MenuOption(name: "Test Views", description: "A basic view that tests many elements of ViewBuilder.") {
            TestViewController()
        }
    ]
}

//
//  LoginViewModel.swift
//  Builder
//
//  Created by Michael Long on 11/22/21.
//

import Foundation
import Resolver
import RxSwift


class LoginViewModel {

    @Variable var username: String? = "michael"
    @Variable var usernameError: String? = nil

    @Variable var password: String? = ""
    @Variable var passwordError: String? = nil

    @Variable var status: String? = nil
    @Variable var error: String? = nil

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.status = "This is a system status message that should be shown to the user."
        }
    }

    func login() {
        usernameError = (username?.isEmpty ?? true) ? "Required" : nil
        passwordError = (password?.isEmpty ?? true) ? "Required" : nil

        let showError = usernameError != nil || passwordError != nil
        error = showError ? "This is an error message that should be shown to the user." : nil
    }

}

//
//  LoginViewModel.swift
//  Builder
//
//  Created by Michael Long on 11/22/21.
//

import Foundation
import Builder
import Factory
import RxSwift
import SwiftUI

class LoginViewModel {

    enum State {
        case loading
        case loaded
    }

    @Variable var state: State = .loading
    
    @Variable var username: String? = "michael"
    @Variable var usernameError: String? = nil

    @Variable var password: String? = ""
    @Variable var passwordError: String? = nil

    @Variable var done: Bool = false
    @Variable var error: String? = nil

    var hideUsernameError: Observable<Bool> {
        $usernameError.asObservable().map { $0 == nil }
    }

    var hidePasswordError: Observable<Bool> {
        $passwordError.asObservable().map { $0 == nil }
    }

    func login() {
        usernameError = (username?.isEmpty ?? true) ? "Required" : nil
        passwordError = (password?.isEmpty ?? true) ? "Required" : nil

        let showError = usernameError != nil || passwordError != nil
        error = showError ? "This is an error message that should be shown to the user." : nil

        if error == nil {
            state = .loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.done = true
            }
        }
    }

    func load() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.state = .loaded
        }
    }

}

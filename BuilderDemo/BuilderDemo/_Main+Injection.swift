//
//  Main+Injection.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import Foundation
import Factory

extension Container {
    static let mainViewModel = Factory(scope: .shared) {
        MainViewModel()
    }
}

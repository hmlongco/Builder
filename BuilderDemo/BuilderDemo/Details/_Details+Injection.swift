//
//  Details+Injection.swift
//  Builder
//
//  Created by Michael Long on 1/17/21.
//

import Foundation
import Factory

extension Container {
    static let detailViewModel = Factory(scope: .shared) {
        DetailViewModel()
    }
}

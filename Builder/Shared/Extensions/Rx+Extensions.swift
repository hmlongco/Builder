//
//  Rx+Extensions.swift
//  Builder
//
//  Created by Michael Long on 2/3/21.
//

import Foundation
import RxSwift

extension RxSwift.ObservableType where Element == Bool {
    func toggle() -> Observable<Bool> {
        self.map { !$0 }
    }
}

//
//  TestServices.swift
//  Builder
//
//  Created by Michael Long on 10/5/21.
//

import Foundation
import RxSwift
import RxCocoa

class TestVariable {
    
    @Variable var name = "Michael"
    @Variable var switched = true

    func test() {
        let view = SwitchView($switched)
        
        _ = $switched.asObservable()
            .subscribe { name in
                print(name)
            }
        
        _ = $name.asObservable()
            .subscribe { name in
                print(name)
            }
        
        name = "Test1"
        
        $name.wrappedValue = "Test2"
    }
}

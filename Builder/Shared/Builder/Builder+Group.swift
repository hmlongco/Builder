//
//  Builder+Group.swift
//  Builder
//
//  Created by Michael Long on 7/7/21.
//

import Foundation

struct Group: ViewConvertable {
    
    private var views: [View]
    
    public init(@ViewResultBuilder  _ views: () -> ViewConvertable) {
        self.views = views().asViews()
    }
        
    func asViews() -> [View] {
        views
    }
    
}

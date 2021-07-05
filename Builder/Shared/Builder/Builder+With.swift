//
//  Builder+With.swift
//  Builder
//
//  Created by Michael Long on 7/2/21.
//

import UIKit

public func With<V:View>(_ view: V, _ configuration: ((_ view: V) -> Void)? = nil) -> V {
    configuration?(view)
    return view
}

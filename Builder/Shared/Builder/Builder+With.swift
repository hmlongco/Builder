//
//  Builder+With.swift
//  Builder
//
//  Created by Michael Long on 7/2/21.
//

import UIKit

public func With<V:ViewConvertable>(_ view: V, _ configuration: (_ view: V) -> Void) -> V {
    configuration(view)
    return view
}

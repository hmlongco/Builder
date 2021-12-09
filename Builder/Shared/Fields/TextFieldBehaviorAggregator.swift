//
//  Extensions.swift
//  Builder
//
//  Created by Michael Long on 11/26/21.
//

import UIKit

class TextFieldBehaviorAggregator: TextFieldBehaviorDelegate {

    private let behaviorList: [TextFieldBehaviorDelegate]

    init(behaviors: TextFieldBehaviorDelegate...) {
        self.behaviorList = behaviors
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        for behavior in self.behaviorList {
            if !behavior.textField(textField, shouldChangeCharactersIn: range, replacementString: string) {
                return false
            }
        }
        return true
    }
}

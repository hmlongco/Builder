//
//  Extensions.swift
//  Builder
//
//  Created by Michael Long on 11/26/21.
//


import UIKit

class MaxWidthTextField: BuilderInternalTextField {

    var maxWidth: Int = 0 {
        didSet {
            if maxWidth > 0 {
                self.behavior = MaxWidthTextFieldBehavior(maxWidth)
            } else {
                self.behavior = nil
            }
        }
    }

}

class MaxWidthTextFieldBehavior: TextFieldBehaviorDelegate {

    var maxWidth: Int = 0

    init(_ maxWidth: Int) {
        self.maxWidth = maxWidth
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let oldText = (textField.text ?? "") as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString

        if maxWidth > 0 && newText.length > maxWidth {
            return false
        }

        return true
    }

}

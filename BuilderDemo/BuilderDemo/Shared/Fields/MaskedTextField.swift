//
//  Extensions.swift
//  Builder
//
//  Created by Michael Long on 11/26/21.
//


import UIKit

class MaskedTextField: BuilderInternalTextField {

    var maskFormat: String? {
        didSet {
            if let maskFormat = maskFormat {
                self.behavior = MaskedTextFieldBehavior(maskFormat)
            } else {
                self.behavior = nil
            }
        }
    }

}

class  MaskedTextFieldBehavior: TextFieldBehaviorDelegate {

    var maskFormat: String?

    init(_ maskFormat: String?) {
        self.maskFormat = maskFormat
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let oldText = (textField.text ?? "") as NSString
        let newText: String = oldText.replacingCharacters(in: range, with: string)

        // masking?
        if let mask = maskFormat, !mask.isEmpty {
            let maskedText = newText.formatDigitsWith(mask: mask)
            if oldText as String != maskedText {
                textField.text = maskedText
                textField.sendActions(for: .editingChanged)
            }
            return false
        }

        return true
    }

}

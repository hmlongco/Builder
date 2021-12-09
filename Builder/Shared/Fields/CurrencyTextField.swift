//
//  Extensions.swift
//  Builder
//
//  Created by Michael Long on 11/26/21.
//


import UIKit

class CurrencyTextField: BuilderInternalTextField {
    var isInputEmpty: Bool {
        return (text?.isEmpty ?? true) || text == "$" || text == "$0.00"
    }

    private var formatter = NumberFormatter()
    private let maxLeftHandSideLimit = 9
    private let maxRightHandSideLimit = 2

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    func sharedInit() {
        delegate = self

        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.roundingMode = .down
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        text = "$"
    }

    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = (textField.text ?? "$")
        let newText: String = (oldText as NSString).replacingCharacters(in: range, with: string) as String

        let components = newText.components(separatedBy: formatter.decimalSeparator)
        var lhs = components[0].stripReturningDigitsOnly()
        let rhs = components.count > 1 ? components[1].stripReturningDigitsOnly() : ""

        if rhs.count > maxRightHandSideLimit {
            return false
        } else if lhs.count > maxLeftHandSideLimit {
            return false
        }

        let originalComponents = oldText.components(separatedBy: formatter.decimalSeparator)
        let deletingRHS = originalComponents.count > 1 && originalComponents[1].count > rhs.count

        let enteringSeparator = string == formatter.decimalSeparator
        if enteringSeparator && lhs.isEmpty {
            lhs = "0"
        }

        let sep: String = enteringSeparator || !rhs.isEmpty || deletingRHS ? formatter.decimalSeparator : ""

        if let number = Double(lhs) {
            textField.text = formatter.string(from: NSNumber(value: number))! + sep + rhs
            let offsetFromEndOfLine = ( (oldText == "$") ? 0 : oldText.count ) - (range.location + range.length)
            if let position = textField.position(from: textField.endOfDocument, offset: -offsetFromEndOfLine) {
                textField.selectedTextRange = textField.textRange(from: position, to: position)
            }
        } else {
            textField.text = "$"
        }

        return false
    }

    override func becomeFirstResponder() -> Bool {
        if text?.isEmpty ?? false {
            text = "$"
        }
        if text == "$", let position = position(from: self.endOfDocument, offset: 0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.selectedTextRange = self.textRange(from: position, to: position)
            }
        }
        return super.becomeFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            textField.text = "$"
            return
        }

        let components = text.components(separatedBy: formatter.decimalSeparator)
        let lhs = components[0].stripReturningDigitsOnly()
        let rhs = components.count > 1 ? components[1].stripReturningDigitsOnly() : "0"
        let rawText = lhs + formatter.decimalSeparator + rhs

        if let number = Double(rawText), number > 0 {
            formatter.minimumFractionDigits = 2
            textField.text = formatter.string(from: NSNumber(value: number))!
            formatter.minimumFractionDigits = 0
        } else {
            textField.text = "$"
        }
    }
}

//
//  String+Extensions.swift
//
//  Copyright (c) 2017 Client Resources Inc. All rights reserved.
//

import Foundation

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }

    // Returns: A formatted phone number in the format: (XXX) XXX-XXXX
    func asPhoneNumber() -> String {
        return self.formatDigitsWith(mask:"(999) 999-9999")
    }

    // Returns: A formatted phone number in the format: XXX-XXX-XXXX
    // This is used for when we need a URL of the number to call
    func asCallablePhoneNumber() -> String {
        return self.formatDigitsWith(mask: "999-999-9999")
    }
}

extension String {
    func stripReturningDigitsOnly() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    func replaceNewlinesWithSpaces() -> String {
        return self.replacingOccurrences(of: "\n", with: " ")
    }

    func formatDigitsWith(mask: String) -> String {
        let cleanNumber = self.stripReturningDigitsOnly()
        var result = ""
        var index = cleanNumber.startIndex
        for ch in mask {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "9" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

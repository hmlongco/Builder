//
//  Extensions.swift
//  Builder
//
//  Created by Michael Long on 11/26/21.
//

import UIKit

class NextAccessoryView: UIToolbar {

    weak var textField: UITextField?

    static func add(to field: UITextField) {
        _ = NextAccessoryView(field)
    }

    init(_ textField: UITextField) {
        self.textField = textField
        super.init(frame: CGRect(x: 0, y: 0, width: 320, height: 50))

        barStyle = .default
        barTintColor = .lightGray
        tintColor = .black

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let title = textField.returnKeyType == .next ? "Next" : "Done"
        let next: UIBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(nextButtonAction))
        next.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)

        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(next)

        self.items = items
        sizeToFit()

        textField.inputAccessoryView = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @objc func nextButtonAction() {
        textField?.resignFirstResponder()
        textField?.sendActions(for: .editingDidEndOnExit)
    }
}

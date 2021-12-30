//
//  FormField.swift
//  Builder
//
//  Created by Michael Long on 12/12/21.
//

import Foundation
import RxSwift
import UIKit


protocol AnyFormField {
    var id: String { get }
    func value<T>() -> T?
    func validates() -> String?
}

struct FormField<Value>: AnyFormField {

    var id: String
    
    @Variable var variable: Value

    private(set) var validators: [(Value) -> String?] = []

    init(id: String, value: Value) {
        self.id = id
        self._variable = Variable(wrappedValue: value)
    }

    init<ID:RawRepresentable>(id: ID, value: Value) where ID.RawValue == String {
        self.id = id.rawValue
        self._variable = Variable(wrappedValue: value)
    }

    func value<T>() -> T? {
        variable as? T
    }

    func validates() -> String? {
        for validator in validators {
            if let error = validator(variable) {
                return error
            }
        }
        return nil
    }

}


extension FormField where Value == String {

    func validate(_ validation: @escaping (_ value: String) -> String?) -> Self {
        validateEmpty { $0.isEmpty ? nil : validation($0) }
    }

    func validateEmpty(_ validation: @escaping (_ value: String) -> String?) -> Self {
        var field = self
        field.validators.append(validation)
        return field
    }

    func isRequired(_ message: String? = nil) -> Self {
        validateEmpty { $0.isEmpty ? message ?? "Required" : nil }
    }

    func isEmail(_ message: String? = nil) -> Self {
        validate { $0 .contains("@") ? nil : message ?? "Must be valid email address" }
    }

    func length(_ count: Int, _ message: String? = nil) -> Self {
        validate { $0.count == count ? nil : message ?? "Must be \(count) characters long" }
    }

    func maxLength(_ count: Int, _ message: String? = nil) -> Self {
        validate { $0.count > count ? nil : message ?? "Must be \(count) characters or less" }
    }

    func minLength(_ count: Int, _ message: String? = nil) -> Self {
        validate { $0.count <= count ? nil : message ?? "Must be \(count) characters or more" }
    }

}

extension FormField where Value == Bool {

    func validate(_ validation: @escaping (_ value: Bool) -> String?) -> Self {
        var field = self
        field.validators.append(validation)
        return field
    }

    func isRequired(_ message: String? = nil) -> Self {
        validate { $0 ? nil : message ?? "Required" }
    }

}

//
//  FormFieldManager.swift
//  Builder
//
//  Created by Michael Long on 12/12/21.
//

import Foundation
import RxSwift

class FormFieldManager<IDS:RawRepresentable> where IDS.RawValue == String {

    @Variable var fields: [AnyFormField] = []
    @Variable var errors: [String:String] = [:]

    @inlinable
    func field(for id: IDS) -> AnyFormField? {
        fields.first(where: { $0.id == id.rawValue })
    }

    @inlinable
    func value<T>(for id: IDS) -> T? {
        field(for: id)?.value()
    }

    func variable<T>(for id: IDS) -> Variable<T> {
        guard let field = field(for: id) as? FormField<T> else {
            fatalError("Missing '\(id.rawValue)' of type \(T.self) in field list")
        }
        return field.$variable
    }

    func placeholder(for id: IDS) -> String {
        return id.rawValue.capitalized
    }

    func error(for id: IDS) -> Observable<String?> {
        $errors.asObservable()
            .map { $0[id.rawValue] }
    }

    var isValid: Bool {
        errors.isEmpty
    }

    func validate() {
        errors = fields
            .reduce(into: [:]) { errors, field in
                if let error = field.validates() {
                    errors[field.id] = error
                }
            }
    }

    func nextID(from id: IDS) -> String? {
        let ids = fields.map { $0.id }
        if let index = ids.firstIndex(where: { $0 == id.rawValue }), index < (ids.count - 1) {
            return ids[index + 1]
        }
        return nil
    }

}


extension MetaTextField {

    init<ID>(manager: FormFieldManager<ID>, id: ID) where ID: RawRepresentable, ID.RawValue == String {
        self
            .identifier(id.rawValue)
            .text(bidirectionalBind: manager.variable(for: id))
            .placeholder(manager.placeholder(for: id))
            .error(bind: manager.error(for: id))
            .returnKeyType(.next)
            .onEditingDidEndOnExit { [weak manager] context in
                if let id = manager?.nextID(from: id), let field = context.find(id), field.canBecomeFirstResponder {
                    field.becomeFirstResponder()
                }
            }
    }

}

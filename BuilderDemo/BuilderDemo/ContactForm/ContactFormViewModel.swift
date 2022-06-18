//
//  ContactFormViewModel.swift
//  Builder
//
//  Created by Michael Long on 12/10/21.
//

import UIKit
import Builder
import RxSwift

enum ContactFormIDS: String, CaseIterable {
    case first
    case last
    case address1
    case address2
    case city
    case state
    case zip
    case email
    case alternateEmail
    case phone
    case agree
}

class ContactFormViewModel: FormFieldManager<ContactFormIDS> {

    @Variable var error: String? = nil

    var hideEmailNotRequired: Observable<Bool> {
        Observable.zip(state(.enabled, for: .email), state(.enabled, for: .alternateEmail))
            .map { $0 || $1 }
    }

    var termsTextColor: Observable<UIColor> {
        error(for: .agree)
            .map { $0 == nil ? .label : .red }
    }

    func configure() {
        fields = [
            FormField(id: ContactFormIDS.first, value: "Michael")
                .isRequired(),

            FormField(id: ContactFormIDS.last, value: "Long")
                .isRequired(),

            FormField(id: ContactFormIDS.address1, value: "1234 East West St")
                .isRequired(),

            FormField(id: ContactFormIDS.address2, value: ""),

            FormField(id: ContactFormIDS.city, value: "Boulder")
                .isRequired(),

            FormField(id: ContactFormIDS.state, value: "CO")
                .isRequired()
                .length(2, "Two letter abbreviation."),

            FormField(id: ContactFormIDS.zip, value: "80303")
                .isRequired(),

            FormField(id: ContactFormIDS.email, value: "hmlongexample.com")
                .isRequired()
                .isEmail(),

            FormField(id: ContactFormIDS.alternateEmail, value: "")
                .isEmail(),

            FormField(id: ContactFormIDS.phone, value: "303-895-0000")
                .validate {
                    $0.stripReturningDigitsOnly().count == 10 ? nil : "Phone number must be 10 digits long"
                },

            FormField(id: ContactFormIDS.agree, value: false)
                .isRequired()
        ]

//        print("INITIAL DISABLE")
//        states[ContactFormIDS.email.rawValue] = .disabled
//        states[ContactFormIDS.alternateEmail.rawValue] = .disabled
    }

    override func placeholder(for id: ContactFormIDS) -> String {
        switch id {
            case .first:
                return "First Name"
            case .last:
                return "Last Name"
            case .address1:
                return "Address Line 1"
            case .address2:
                return "Address Line 2 (optional)"
            case .alternateEmail:
                return "Alternate Email (optional)"
            default:
                return id.rawValue.capitalized
        }
   }

    override func validate() {
        super.validate() // default behavior
        error = errors.isEmpty ? nil : "Please correct the following errors..."
    }

}


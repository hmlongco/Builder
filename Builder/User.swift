//
//  User.swift
//  ViewBuilder
//
//  Created by Michael Long on 10/18/20.
//  Copyright © 2020 Michael Long. All rights reserved.
//

import Foundation
import RxSwift
import Combine

// MARK: - User
struct User: Codable {
    let id: ID
    let name: Name
    let gender: String?
    let location: Location?
    let email: String?
    let login: Login?
    let dob: Dob?
    let phone: String?
    let cell: String?
    let picture: Picture?
    let nat: String?
}

// MARK: - Dob
struct Dob: Codable {
    let date: String?
    let age: Int?
}

// MARK: - ID
struct ID: Codable {
    let name: String?
    let value: String?
}

// MARK: - Location
struct Location: Codable {
    let street: Street?
    let city: String?
    let state: String?
//    let postcode: String?
}

struct Street: Codable {
    let number: Int?
    let name: String?
}

// MARK: - Login
struct Login: Codable {
    let uuid: String?
    let username: String?
    let password: String?
    let salt: String?
    let md5: String?
    let sha1: String?
    let sha256: String?
}

// MARK: - Name
struct Name: Codable {
    let title: String?
    let first: String
    let last: String
}

// MARK: - Picture
struct Picture: Codable {
    let large: String?
    let medium: String?
    let thumbnail: String?
}


extension User {

    var fullname: String {
        return name.first + " " + name.last
    }

}

#if MOCK
extension User {

    static var mockJQ: User {
        return User(
            id: ID(name: "21", value: "21"),
            name: Name(title: "Mr.", first: "Jonny", last: "Quest"),
            gender: "M",
            location: nil,
            email: "jquest@quest.com",
            login: nil,
            dob: nil,
            phone: "303-555-8888",
            cell: nil,
            picture: Picture(large: nil, medium: "User-JQ", thumbnail: "User-JQ"),
            nat: "US"
        )
    }

    static var mockTS: User {
        return User(
            id: ID(name: "21", value: "21"),
            name: Name(title: "Mr.", first: "Tom", last: "Swift"),
            gender: "M",
            location: nil,
            email: "tomswift@swiftenterprises.com",
            login: nil,
            dob: nil,
            phone: "402-555-9999",
            cell: nil,
            picture: nil,
            nat: "US"
        )
    }

}
#endif

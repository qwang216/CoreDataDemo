//
//  Person.swift
//  CoreDataDemo
//
//  Created by Jason Wang on 12/20/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

import Foundation

extension Person {
    func parse(dict: [String: Any]) {

        guard let firstNameString = dict["firstName"] as? String, let lastNameString = dict["lastName"] as? String, let ageInt = dict["age"] as? Int else { return }
        self.firstName = firstNameString
        self.lastName = lastNameString
        self.age = Int16(ageInt)
    }
}

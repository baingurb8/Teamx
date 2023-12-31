//
//  Coach.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-15.
//

import Foundation
import FirebaseFirestoreSwift


struct Coach: Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var firstName: String = ""
    var lastName: String = ""
    var teams: [Team] = []

    init() {
        self.firstName = "NA"
        self.lastName = "NA"
    }

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

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
    var role: String = ""
    var uid: String = "" 
    var teams: [Team] = []
    var clubIDs: [String] = [] // Array to hold club IDs

    init() {
        self.firstName = "NA"
        self.lastName = "NA"
    }

    init(firstName: String, lastName: String, role: String = "coach") {
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
    }
}

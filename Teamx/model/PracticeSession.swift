//
//  PracticeSession.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-15.
//

import Foundation
import FirebaseFirestoreSwift

struct PracticeSession: Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var date: Date = Date()
    var location: String = ""
    var team: Team?

    init() {
        self.location = "NA"
    }

    init(date: Date, location: String, team: Team?) {
        self.date = date
        self.location = location
        self.team = team
    }
}

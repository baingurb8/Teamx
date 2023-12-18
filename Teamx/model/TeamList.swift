//
//  TeamList.swift
//  Teamx
//
//  Created by Arshdeep Singh on 2023-12-11.
//

import Foundation

struct TeamList: Codable, Hashable {
    
    var firstName: String
    var lastName: String
    var birthday: Date
    var position: Position
    var role: String
    var uid: String = ""
    var clubs: [Club]
    var teams: [Team]
    var attendanceCount: Int = 0
    
    init(firstName: String = "", lastName: String = "", position: Position = .attacker, role: String = "player", uid: String = "", birthday: Date = Date(), clubs: [Club] = [], teams: [Team] = []) {
        self.firstName = firstName
        self.lastName = lastName
        self.position = position
        self.role = role
        self.uid = uid
        self.birthday = birthday
        self.clubs = clubs
        self.teams = teams
    }
}

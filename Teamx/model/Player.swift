//
//  Player.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-15.
//
import Foundation
import FirebaseFirestoreSwift

enum Position: String, Codable {
    case attacker
    case midfielder
    case defender
    case goalie
}

struct Player: Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var firstName: String
    var lastName: String
    var birthday: Date
    var position: Position
    var clubs: [Club]
    var teams: [Team]

    init(firstName: String = "", lastName: String = "", position: Position = .attacker, birthday: Date = Date(), clubs: [Club] = [], teams: [Team] = []) {
        self.firstName = firstName
        self.lastName = lastName
        self.position = position
        self.birthday = birthday
        self.clubs = clubs
        self.teams = teams
    }
}



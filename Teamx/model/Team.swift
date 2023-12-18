//
//  Team.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-15.
//
import Foundation
import FirebaseFirestoreSwift

struct Team: Codable, Hashable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String = ""
    var players: [Player] = []

    init() {
        self.name = "NA"
    }

    init(name: String) {
        self.name = name
    }
}

//
//  Club.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-15.
//
import Foundation
import FirebaseFirestoreSwift

struct Club: Codable, Hashable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String = ""
    var code: String = ""
    var teams: [Team] = []
    var players: [Player] = []
    var creationDate: Date?
    var coachID: String?
    var playerID: String?

    init() {
        self.name = "NA"
        self.code = Club.generateUniqueCode() 
        self.creationDate = Date()
    }

    init(name: String) {
        self.name = name
        
        self.code = Club.generateUniqueCode()
        self.creationDate = Date()
    }

    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String else {
            return nil
        }
        self.init(name: name)
    }

    static func generateUniqueCode() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in characters.randomElement()! })
    }
}





//
//  Club.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-15.
//
import Foundation
import FirebaseFirestoreSwift

struct Club: Codable, Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String = ""
    var code: String = generateUniqueCode()
    var teams: [Team] = []
    var players: [Player] = []
    var creationDate: Date?

    init() {
        self.name = "NA"
        self.creationDate = Date() // Set the creation date when initializing a club

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
            // Implement logic to generate a unique code, e.g., a random alphanumeric string
            let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<6).map { _ in characters.randomElement()! })
        }
    }




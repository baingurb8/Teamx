//
//  FireDBHelper.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-15.
//

import Foundation
import FirebaseFirestore

class FireDBHelper : ObservableObject{
    
    @Published var clubList = [Club]()
    @Published var teamList = [TeamList]()
    @Published var playersList = [Player]()
    
    private let db : Firestore
    
    //singleton design pattern
    //singleton object
    
    private static var shared : FireDBHelper?
    
    private let COLLECTION_NAME = "Clubs"
    private let TEAMS_COLLECTION = "Teams"
    private let ATTRIBUTE_NAME = "clubname"
    private let ATTRIBUTE_DATE = "date"
    private let ATTRIBUTE_CODE = "code"
    private let COACHES_COLLECTION = "Coaches"
    private let PLAYERS_COLLECTION = "Players"

    
    private init(database : Firestore){
        self.db = database
    }
    
    static func getInstance() -> FireDBHelper{
        
        if (self.shared == nil){
            shared = FireDBHelper(database: Firestore.firestore())
        }
        
        return self.shared!
    }
    
    func retrieveUserDetails(for uid: String, completion: @escaping (Result<[String: Any]?, Error>) -> Void) {
        self.db.collection(COACHES_COLLECTION).whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let documents = snapshot?.documents, !documents.isEmpty {
                if let coachDetails = documents.first?.data() {
                    completion(.success(coachDetails))
                } else {
                    completion(.success(nil))
                }
            } else {
                self.db.collection(self.PLAYERS_COLLECTION).whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    if let documents = snapshot?.documents, !documents.isEmpty {
                        if let playerDetails = documents.first?.data() {
                            completion(.success(playerDetails))
                        } else {
                            completion(.success(nil))
                        }
                    } else {
                        completion(.success(nil))
                    }
                }
            }
        }
    }




    
    func insertCoach(coach: Coach) {
            do {
                try self.db.collection(COACHES_COLLECTION).addDocument(from: coach)
            } catch let err as NSError {
                print("Unable to insert coach: \(err)")
            }
        }
    
    
    func insertPlayer(player: Player) {
            do {
                try self.db.collection(PLAYERS_COLLECTION).addDocument(from: player)
            } catch let err as NSError {
                print("Unable to insert player: \(err)")
            }
        }
    
    func retrieveClubsForPlayer(playerID: String, completion: @escaping ([Club]) -> Void) {
        db.collection(PLAYERS_COLLECTION)
            .whereField("uid", isEqualTo: playerID)
            .getDocuments { [self] snapshot, error in
                if let error = error {
                    print("Error fetching player document: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let playerDocument = snapshot?.documents.first else {
                    print("Player document not found")
                    completion([])
                    return
                }

                if let clubIDs = playerDocument.data()["clubs"] as? [String] {
                    var clubs = [Club]()
                    let dispatchGroup = DispatchGroup()

                    for clubID in clubIDs {
                        dispatchGroup.enter()

                        self.db.collection(COLLECTION_NAME).document(clubID).getDocument { document, error in
                            defer {
                                dispatchGroup.leave()
                            }

                            if let error = error {
                                print("Error fetching club with ID \(clubID): \(error.localizedDescription)")
                                return
                            }

                            if let document = document, document.exists {
                                if let club = document.data().flatMap({ $0 as? [String: Any] }) {
                                    if let clubObject = Club(dictionary: club) {
                                        clubs.append(clubObject)
                                    }
                                }
                            }
                        }
                    }

                    dispatchGroup.notify(queue: .main) {
                        completion(clubs)
                    }
                } else {
                    completion([])
                }
            }
    }

    
    func createClubForCoach(coachID: String, club: Club, completion: @escaping (Club?) -> Void) {
        
        do {
            var updatedClub = club

            let clubRef = try db.collection(COLLECTION_NAME).addDocument(from: updatedClub)
            let clubID = clubRef.documentID

            updatedClub.id = clubID

            self.db.collection(COACHES_COLLECTION).whereField("uid", isEqualTo: coachID).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching coach document: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let coachDocument = snapshot?.documents.first else {
                    print("Coach document not found")
                    completion(nil)
                    return
                }

                let clubCode = updatedClub.code
                coachDocument.reference.updateData(["clubIDs": FieldValue.arrayUnion([clubCode])]) { error in
                    if let error = error {
                        print("Error updating coach document: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        completion(updatedClub)
                    }
                }
            }
        } catch let error {
            print("Error creating club for coach: \(error.localizedDescription)")
            completion(nil)
        }
    }


    func retrieveClubsForCoach(coachID: String, completion: @escaping ([Club]) -> Void) {
        db.collection(COACHES_COLLECTION)
            .whereField("uid", isEqualTo: coachID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching coach document: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let coachDocument = snapshot?.documents.first else {
                    print("Coach document not found")
                    completion([])
                    return
                }

                if let clubIDs = coachDocument.data()["clubIDs"] as? [String] {
                    var clubs = [Club]()
                    let dispatchGroup = DispatchGroup()

                    for clubID in clubIDs {
                        dispatchGroup.enter()

                        self.db.collection("Clubs").whereField("code", isEqualTo: clubID).getDocuments { clubDocuments, clubError in
                            defer {
                                dispatchGroup.leave()
                            }

                            if let clubError = clubError {
                                print("Error fetching club with ID \(clubID): \(clubError.localizedDescription)")
                                return
                            }

                            clubDocuments?.documents.forEach { clubDocument in
                                if let clubObject = try? clubDocument.data(as: Club.self) {
                                    clubs.append(clubObject)
                                }
                            }
                        }
                    }

                    dispatchGroup.notify(queue: .main) {
                        completion(clubs)
                    }
                } else {
                    print("No club IDs found for the coach")
                    completion([])
                }
            }
    }





    
    func createTeamForClub(clubCode: String, team: Team, completion: @escaping (String?) -> Void) {
        do {
            var updatedTeam = team

            let teamRef = try db.collection("Teams").addDocument(from: updatedTeam)
            let teamID = teamRef.documentID

            self.db.collection("Clubs").whereField("code", isEqualTo: clubCode).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching club: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let clubDocument = snapshot?.documents.first else {
                    print("Club not found")
                    completion(nil)
                    return
                }

                clubDocument.reference.updateData([
                    "teams": FieldValue.arrayUnion([teamID])
                ]) { error in
                    if let error = error {
                        print("Error updating club document: \(error.localizedDescription)")
                        completion(nil)
                    } else {
                        completion(teamID)
                    }
                }
            }
        } catch let error {
            print("Error creating team for club: \(error.localizedDescription)")
            completion(nil)
        }
    }



    func retrieveTeamsForClub(clubID: String, completion: @escaping ([Team]) -> Void) {
        self.db.collection("Clubs").document(clubID).getDocument { document, error in
            if let error = error {
                print("Error fetching club document: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let clubDocument = document, clubDocument.exists else {
                print("Club document not found")
                completion([])
                return
            }

            if let teamIDs = clubDocument.data()?["teams"] as? [String] {
                var teams = [Team]()
                let dispatchGroup = DispatchGroup()

                for teamID in teamIDs {
                    dispatchGroup.enter()

                    self.db.collection("Teams").document(teamID).getDocument { document, error in
                        defer {
                            dispatchGroup.leave()
                        }

                        if let error = error {
                            print("Error fetching team with ID \(teamID): \(error.localizedDescription)")
                            return
                        }

                        if let document = document, document.exists {
                            if let teamData = document.data() {
                                let team = Team(
                                    name: teamData["name"] as? String ?? ""
                                )
                                teams.append(team)
                            }
                        }
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    completion(teams)
                }
            } else {
                completion([])
            }
        }
    }


    
    
    func retrieveAllPlayers(){
        db.collection(PLAYERS_COLLECTION).order(by: "firstName", descending: false).addSnapshotListener{
            snapshot, error in
            guard let snapshot = snapshot else {
                print("Unable to retrieve players: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.playersList = snapshot.documents.compactMap{ info in
                do {
                    return try info.data(as: Player.self)
                } catch {
                    print("Error decoding team: \(error.localizedDescription)")
                    return nil
                }
            }
                    
        }
    }
    
    func insertTeam(team: Player) {
            do {
                try self.db.collection(TEAMS_COLLECTION).addDocument(from: team)
            } catch let err as NSError {
                print("Unable to insert team: \(err)")
            }
        }
    
    func retrieveAllTeams() {
        db.collection(TEAMS_COLLECTION).addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Unable to retrieve teams: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.teamList = snapshot.documents.compactMap { document in
                do {
                    return try document.data(as: TeamList.self)
                } catch {
                    print("Error decoding team: \(error.localizedDescription)")
                    return nil
                }
            }
        }
        
    }


    
    func insertClub(stud : Club){
            do{
                let uniqueCode = Club.generateUniqueCode()
                
                var clubWithCode = stud
                clubWithCode.code = uniqueCode
                
                let currentDate = Date()
                var clubWithCreationDate = clubWithCode
                clubWithCreationDate.creationDate = currentDate
                
                try self.db.collection(COLLECTION_NAME).addDocument(from: clubWithCreationDate)
                
            }catch let err as NSError{
                print(#function, "Unable to insert : \(err)")
            }
        }
    
    func joinClub(with code: String, playerID: String, completion: @escaping (Bool) -> Void) {
        db.collection(COLLECTION_NAME)
            .whereField("code", isEqualTo: code)
            .getDocuments { [self] snapshot, error in
                if let error = error {
                    print("Error fetching club: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let clubDocument = snapshot?.documents.first else {
                    print("Club not found")
                    completion(false)
                    return
                }

                let clubID = clubDocument.documentID

                let playerData: [String: Any] = ["id": playerID]
                db.collection(COLLECTION_NAME).document(clubID).updateData([
                    "players": FieldValue.arrayUnion([playerData])
                ]) { [self] error in
                    if let error = error {
                        print("Error updating club document: \(error.localizedDescription)")
                        completion(false)
                        return
                    }

                    self.db.collection(PLAYERS_COLLECTION)
                        .whereField("uid", isEqualTo: playerID)
                        .getDocuments { snapshot, error in
                            if let error = error {
                                print("Error fetching player document: \(error.localizedDescription)")
                                completion(false)
                                return
                            }

                            guard let playerDocument = snapshot?.documents.first else {
                                print("Player document not found")
                                completion(false)
                                return
                            }

                            let playerRef = playerDocument.reference
                            playerRef.updateData([
                                "clubs": FieldValue.arrayUnion([clubID])
                            ]) { error in
                                if let error = error {
                                    print("Error updating player document: \(error.localizedDescription)")
                                    completion(false)
                                    return
                                }
                                completion(true)
                            }
                        }
                }
            }
    }




    
    func deleteClub(docIDtoDelete : String){
        self.db
            .collection(COLLECTION_NAME)
            .document(docIDtoDelete)
            .delete{error in
                if let err = error{
                    print(#function, "Unable to delete : \(err)")
                }else{
                    print(#function, "Document deleted successfully")
                }
            }
    }
    
    func retrieveAllClubs(){
        
        do{
            
            self.db
                .collection(COLLECTION_NAME)
                .order(by: ATTRIBUTE_NAME, descending: true)
                .addSnapshotListener( { (snapshot, error) in
                    
                    guard let result = snapshot else{
                        print(#function, "Unable to retrieve snapshot : \(error)")
                        return
                    }
                    
                    print(#function, "Result : \(result)")
                    
                    result.documentChanges.forEach{ (docChange) in
                        
                        do{
                            //obtain the document as Student class object
                            var stud = try docChange.document.data(as: Club.self)
                            stud.creationDate = docChange.document.data()[self.ATTRIBUTE_DATE] as? Date
                            
                            print(#function, "stud from db : id : \(stud.id) clubname : \(stud.name)")
                            
                            //check if the changed document is already in the list
                            let matchedIndex = self.clubList.firstIndex(where: {
                                ($0.id?.elementsEqual(stud.id!))!})
                            
                            if docChange.type == .added{
                                
                                if (matchedIndex != nil){
                                    //the objecy is already in the list
                                    //do nothing to avoid duplicates
                                }else{
                                    self.clubList.append(stud)
                                }
                                
                                print(#function, "New document added : \(stud)")
                            }
                            
                            if docChange.type == .modified{
                                print(#function, "Document updated : \(stud)")
                                
                                //if(matchedIndex != nil){
                                    
                                   // self.studentList[matchedIndex!] = stud
                                    //the document object is already in the list
                                    //replace existing documeny
                               // }
                                
                            }
                            
                            if docChange.type == .removed{
                                print(#function, "Document deleted : \(stud)")
                            }
                            
                        }catch let err as NSError{
                            print(#function, "Unable to access document change : \(err)")
                        }
                        
                    }
                })
            
        }catch let err as NSError{
            print(#function, "Unable to retrieve \(err)" )
        }
        
    }
    
    
    func updateClub( updatedClubIndex : Int ){
        
        let currentDate = Date()
        self.db
            .collection(COLLECTION_NAME)
            .document(self.clubList[updatedClubIndex].id!)
            .updateData([ATTRIBUTE_NAME : self.clubList[updatedClubIndex].name,
                         ATTRIBUTE_DATE: currentDate
                        ]){ error in
                
                if let err = error{
                    print(#function, "Unable to update document : \(err)")
                }else{
                    print(#function, "Document updated successfully")
                }
                
            }
    }
    
}

extension FireDBHelper {
    func updatePlayerAttendance(player: Player) {
        guard let id = player.id else { return }
        db.collection(PLAYERS_COLLECTION).document(id).updateData(["attendanceCount": player.attendanceCount]) { error in
            if let error = error {
                print("Error updating attendance: \(error)")
            } else {
                print("Attendance updated successfully")
            }
        }
    }
}

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
    
    private let db : Firestore
    
    //singleton design pattern
    //singleton object
    
    private static var shared : FireDBHelper?
    
    private let COLLECTION_NAME = "Clubs"
    private let ATTRIBUTE_NAME = "clubname"
    private let ATTRIBUTE_CODE = "code" 

    
    private init(database : Firestore){
        self.db = database
    }
    
    static func getInstance() -> FireDBHelper{
        
        if (self.shared == nil){
            shared = FireDBHelper(database: Firestore.firestore())
        }
        
        return self.shared!
    }
    
    func insertClub(stud : Club){
            do{
                // Generate a unique code for the club
                let uniqueCode = Club.generateUniqueCode()
                
                // Add the generated code to the club object
                var clubWithCode = stud
                clubWithCode.code = uniqueCode
                
                // Insert the club into the database
                try self.db.collection(COLLECTION_NAME).addDocument(from: clubWithCode)
                
            }catch let err as NSError{
                print(#function, "Unable to insert : \(err)")
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
                            let stud = try docChange.document.data(as: Club.self)
                            
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
        
        self.db
            .collection(COLLECTION_NAME)
            .document(self.clubList[updatedClubIndex].id!)
            .updateData([ATTRIBUTE_NAME : self.clubList[updatedClubIndex].name,
                        ]){ error in
                
                if let err = error{
                    print(#function, "Unable to update document : \(err)")
                }else{
                    print(#function, "Document updated successfully")
                }
                
            }
    }
    
}

//
//  AuthenticationHelper.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthenticationHelper: ObservableObject{
    
    
    func registerUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user.uid))
            } else {
                let unknownError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                completion(.failure(unknownError))
            }
        }
    }


    func loginUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user.uid)) // Return the user's UID as String
            } else {
                let customError = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                completion(.failure(customError))
            }
        }
    }

    func signOutUser() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

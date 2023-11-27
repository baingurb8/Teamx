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
    func registerUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }

    func loginUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error)
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

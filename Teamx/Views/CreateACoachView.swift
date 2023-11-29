//
//  CreateACoach.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI

struct CreateACoachView: View {
    @EnvironmentObject var dbHelper: FireDBHelper
    @Environment(\.dismiss) var dismiss
    
    @StateObject var authManager = AuthenticationHelper()
    
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: self.$firstName)
                    TextField("Last Name", text: self.$lastName)
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)
                }
            }
            
            Button(action: {
                self.addCoach()
            }) {
                Text("Create Coach")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle("Create a Coach")
    }
    private func addCoach() {
        let newCoach = Coach(firstName: firstName, lastName: lastName)
        
        authManager.registerUser(email: email, password: password) { result in
            switch result {
            case .success(let userID):
                var coachWithID = newCoach
                coachWithID.uid = userID
                dbHelper.insertCoach(coach: coachWithID)
                dismiss()
            case .failure(let error):
                print("Error registering coach: \(error.localizedDescription)")
                // Handle error if needed
            }
        }
    }
}

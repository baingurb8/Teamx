//
//  CreateACoach.swift
//  Teamx
//
//  Created by Gurbir and Parth on 2023-11-22.
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
    @State private var showAlert = false
    @State private var alertMessage = "Kindly check firebase database"
    
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

            if showAlert {
                CustomAlertView(message: alertMessage, isVisible: $showAlert)
                    .transition(.scale)
            }
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
                alertMessage = "Coach created successfully!"
                showAlert = true
            case .failure(let error):
                print("Error registering coach: \(error.localizedDescription)")
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

struct CustomAlertView: View {
    var message: String
    @Binding var isVisible: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Alert")
                    .font(.headline)
                    .padding()
                    .foregroundColor(Color.white)

                Text(message)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing) // Gradient background
                    )
                    .foregroundColor(Color.black) // Text color

                Button("OK") {
                    withAnimation {
                        isVisible = false
                    }
                }
                .padding()
                .foregroundColor(Color.white) // Button text color
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing) // Gradient background
            )
            .cornerRadius(20)
            .shadow(radius: 10)
            .scaleEffect(isVisible ? 1 : 0.5)
            .opacity(isVisible ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0), value: isVisible)
            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5) // Dynamic sizing
        }
    }
}

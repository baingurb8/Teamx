//
//  MakeAPlayer.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI

struct MakeAPlayerView: View {
    @EnvironmentObject var dbHelper: FireDBHelper
    @Environment(\.dismiss) var dismiss
    
    @StateObject var authManager = AuthenticationHelper() // Add an instance of AuthenticationManager


    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthday = Date()
    @State private var selectedPosition = Position.attacker // Default position
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: self.$firstName)
                    TextField("Last Name", text: self.$lastName)
                    DatePicker("Birthday", selection: self.$birthday, displayedComponents: .date)
                    TextField("Email", text: $email)
                    SecureField("Password", text: $password)                }

                Section(header: Text("Position")) {
                    Picker("Position", selection: self.$selectedPosition) {
                        ForEach(Position.allCases, id: \.self) { position in
                            Text(position.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }

            Button(action: {
                self.addPlayer()
            }) {
                Text("Create Player")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationBarTitle("Create a Player")
    }
    private func addPlayer() {
            let newPlayer = Player(firstName: firstName, lastName: lastName, position: selectedPosition, birthday: birthday)
            dbHelper.insertPlayer(player: newPlayer)

            // Register the player using the AuthenticationManager after adding to the database
            authManager.registerUser(email: email, password: password) { error in
                if let error = error {
                    print("Error registering player: \(error.localizedDescription)")
                    // Handle error if needed
                } else {
                    print("Player registered successfully")
                    dismiss()
                }
            }
        }
    }

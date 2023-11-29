//
//  MakeAPlayer.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI


struct MakeAPlayerView: View {
    @EnvironmentObject var dbHelper: FireDBHelper
    @StateObject var authManager = AuthenticationHelper()

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var birthday = Date()
    @State private var selectedPosition = Position.attacker // Default position
    @State private var email = ""
    @State private var password = ""
    @State private var goToLogin = false 

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("First Name", text: self.$firstName)
                        TextField("Last Name", text: self.$lastName)
                        DatePicker("Birthday", selection: self.$birthday, displayedComponents: .date)
                        TextField("Email", text: $email)
                        SecureField("Password", text: $password)
                    }

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
        .navigationViewStyle(StackNavigationViewStyle())
        .background(
            NavigationLink(
                destination: LoginView(),
                isActive: $goToLogin,
                label: EmptyView.init
            )
        )
    }

    private func addPlayer() {
        let newPlayer = Player(firstName: firstName, lastName: lastName, position: selectedPosition, birthday: birthday)
        authManager.registerUser(email: email, password: password) { result in
            switch result {
            case .success(let userID):
                var playerWithID = newPlayer
                playerWithID.uid = userID
                dbHelper.insertPlayer(player: playerWithID)
                print("Player registered")
                goToLogin = true
            case .failure(let error):
                print("Error registering player: \(error.localizedDescription)")
            }
        }
    }
}

///
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
    @State private var selectedPosition = Position.attacker
    @State private var email = ""
    @State private var password = ""
    @State private var goToLogin = false
    @State private var showAlert = false
    @State private var alertMessage = ""

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
                
                if showAlert {
                    MainAlertView(message: alertMessage, isVisible: $showAlert)
                        .transition(.scale)
                }
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
            DispatchQueue.main.async {
                switch result {
                case .success(let userID):
                    var playerWithID = newPlayer
                    playerWithID.uid = userID
                    dbHelper.insertPlayer(player: playerWithID)
                    self.alertMessage = "Success! Player Created."
                    self.showAlert = true
                case .failure(let error):
                    self.alertMessage = "Error registering player: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
}

struct MainAlertView: View {
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

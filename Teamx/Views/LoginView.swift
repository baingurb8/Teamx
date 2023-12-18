//
//  LoginView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var dbHelper: FireDBHelper
    @StateObject var authManager = AuthenticationHelper()
    
    @State private var email = ""
    @State private var password = ""
    @State private var userDetails: [String: Any]?
    @State private var isLoggedIn = false
    @State private var shouldNavigate = false


    var body: some View {
        NavigationView {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    login() 
                }) {
                    Text("Login")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                
            }
            .padding()
            .navigationBarTitle("Login")
            .background(
                NavigationLink(
                    destination: getDestinationView(),
                    isActive: $shouldNavigate,
                    label: { EmptyView() }
                )
            )
        }
    }
    
    private func login() {
        authManager.loginUser(email: email, password: password) { result in
            switch result {
            case .success(let userID):
                dbHelper.retrieveUserDetails(for: userID) { userDetailsResult in
                    switch userDetailsResult {
                    case .success(let userDetails):
                        if let userDetails = userDetails {
                            self.userDetails = userDetails
                            if let role = userDetails["role"] as? String {
                                print("Logged in as: \(role)")
                                DispatchQueue.main.async {
                                    isLoggedIn = true
                                    shouldNavigate = true
                                }
                            } else {
                                print("Role not found in user details")
                            }
                        } else {
                            print("User details not found")
                        }
                    case .failure(let error):
                        print("Error retrieving user details: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error logging in: \(error.localizedDescription)")
            }
        }
    }
    
    private func getDestinationView() -> some View {
        if let role = userDetails?["role"] as? String {
            switch role {
            case "coach":
                let coachID = userDetails?["uid"] as? String ?? ""
                return AnyView(CoachView(userDetails: userDetails ?? [:]))
            case "player":
                return AnyView(PlayerView(userDetails: userDetails ?? [:]))
            default:
                return AnyView(EmptyView())
            }
        } else {
            return AnyView(EmptyView())
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

//
//  ContentView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-08.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            VStack {
                NavigationLink(destination: MakeAPlayerView()) {
                    Text("Create a Player")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                NavigationLink(destination: CreateACoachView()) {
                    Text("Create a Coach")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()

                NavigationLink(destination: LoginView()) {
                    Text("Login")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .padding()
                .foregroundColor(.cyan)
                .cornerRadius(5)
              
            }
            .navigationBarTitle("TeamX")
    
        }
    }
}

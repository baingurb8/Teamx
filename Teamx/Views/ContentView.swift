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
            HStack {
                NavigationLink(destination: MakeAClubView()) {
                    Text("Make a Club")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                NavigationLink(destination: JoinClubView()) {
                    Text("Join a Club")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("TeamX")
        }
    }
}

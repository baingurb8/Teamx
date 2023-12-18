//
//  PlayerView.swift
//  Teamx
//
//  Created by Gurbir Bains and Arshdeep Singh on 2023-11-22.
//

import SwiftUI
import CoreLocation


struct PlayerView: View {
    let userDetails: [String: Any]
    @StateObject var dbHelper = FireDBHelper.getInstance()
    @State private var selectedClub: Club?
    @State private var showJoinClubSheet = false
    @State private var clubCode = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, Player!")
                
                List {
                    ForEach(dbHelper.clubList) { club in
                        Button(action: {
                            selectedClub = club
                        }) {
                            Text(club.name)
                        }
                    }
                }
                
                NavigationLink(destination: selectedClub.map { TeamView(club: $0) }) {
                    Text("View Teams")
                }
                
                Button("Join a Club") {
                    showJoinClubSheet.toggle()
                }
            }
            .sheet(isPresented: $showJoinClubSheet) {
                VStack {
                    TextField("Enter Club Code", text: $clubCode)
                        .padding()
                    
                    Button("Join") {
                        joinClub()
                    }
                    .padding()
                }
            }
            .alert(isPresented: $showAlert) {Alert(title: Text("Join Club Failed"), message: Text("Club not found. Please enter a valid code."), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                retrievePlayerClubs()
            }
        }
    }
    
    func retrievePlayerClubs() {
        if let playerID = userDetails["uid"] as? String {
            dbHelper.retrieveClubsForPlayer(playerID: playerID) { clubs in
                DispatchQueue.main.async {
                    self.dbHelper.clubList = clubs
                }
            }
        }
    }
    
    func joinClub() {
        let playerID = userDetails["uid"] as? String ?? ""
        
        dbHelper.joinClub(with: clubCode, playerID: playerID) { success in
            if success {
                retrievePlayerClubs()
                showJoinClubSheet.toggle()
            } else {
                showAlert.toggle()
            }
        }
    }
}
    


struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(userDetails: [:])
    }
}

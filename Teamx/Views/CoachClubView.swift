//
//  ClubView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI

struct CoachClubView: View {
    let userDetails: [String: Any]
    @StateObject var dbHelper = FireDBHelper.getInstance()
    @State private var selectedClub: Club?

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(userDetails["firstName"] as? String ?? "")")
                
                List {
                    ForEach(dbHelper.clubList) { club in
                        Button(action: {
                            selectedClub = club 
                        }) {
                            Text(club.name)
                        }
                    }
                }
                
                NavigationLink(destination: selectedClub.map { CoachTeamView(club: $0) }) {
                    Text("View Teams")
                }
                
                NavigationLink(destination: MakeAClubView(userDetails: userDetails)) {
                    Text("Create a Club")
                }
            }
        }
        .onAppear {
            retrieveClubs()
        }
    }

    func retrieveClubs() {
        if let coachID = userDetails["uid"] as? String {
            dbHelper.retrieveClubsForCoach(coachID: coachID) { clubs in
                DispatchQueue.main.async {
                    print(clubs) 

                    self.dbHelper.clubList = clubs
                }
            }
        }
    }
}


struct CoachhClubView_Previews: PreviewProvider {
    static var previews: some View {
        CoachClubView(userDetails: [:])
    }
}

//
//  AddTeamView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-12-12.
//

import SwiftUI

struct AddTeamView: View {
    @State private var teamName = ""
    let club: Club
    @State private var teamAdded = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Team Details")) {
                    TextField("Team Name", text: $teamName)
                }
                
                Section(header: Text("Club Code")) {
                    Text(club.code)
                }
                
                Button("Add Team") {
                    addTeam()
                }
            }
            .navigationTitle("Add Team to \(club.name)")
            .navigationBarItems(trailing: NavigationLink(
                destination: CoachTeamView(club: club),
                isActive: $teamAdded,
                label: { EmptyView() }
            ))
        }
    }
    
    func addTeam() {
        let newTeam = Team(name: teamName)
        
        print("Club code to be used: \(club.code)")
        
        FireDBHelper.getInstance().createTeamForClub(clubCode: club.code, team: newTeam) { createdTeamID in
            if let createdTeamID = createdTeamID {
                print("Team added with ID: \(createdTeamID)")
                teamAdded = true
            } else {
                print("Failed to add team.")
            }
        }
    }
}



struct AddTeamView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleClub = Club(name: "Sample Club")
        return AddTeamView(club: sampleClub)
    }
}

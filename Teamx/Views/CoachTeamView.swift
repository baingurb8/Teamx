//
//  CoachTeamView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-12-12.
//

import SwiftUI

struct CoachTeamView: View {
    
    @State private var selectedTeam: Team?
    @State private var showAddTeamSheet = false
    let club: Club
    @State private var teams = [Team]()

    var body: some View {
        VStack {
            Text("Club: \(club.name)")
                .font(.title)
            
            List(teams, id: \.id) { team in
                Button(action: {
                    selectedTeam = team
                }) {
                    Text(team.name)
                }
            }
            
            Button("Add Team") {
                showAddTeamSheet.toggle()
            }
            
            if let selectedTeam = selectedTeam {
                NavigationLink(destination: CreatePracticeSessionView(team: selectedTeam)) {
                    Text("Create Practice Session")
                }
                
                NavigationLink(destination: AddPlayersToTeamView(team: selectedTeam)) {
                    Text("Add Players to Team")
                }
            }
        }
        .onAppear {
            retrieveTeamsForClub()
        }
        .sheet(isPresented: $showAddTeamSheet) {
            AddTeamView(club: club)
        }
    }
    
    func retrieveTeamsForClub() {
        FireDBHelper.getInstance().retrieveTeamsForClub(clubID: club.id ?? "") { fetchedTeams in
            self.teams = fetchedTeams
        }
    }
}

struct CoachTeamView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleClub = Club(name: "Sample Club")
        return CoachTeamView(club: sampleClub)
    }
}

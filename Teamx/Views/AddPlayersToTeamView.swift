//
//  AddPlayersToTeamView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-12-12.
//

import SwiftUI

struct AddPlayersToTeamView: View {
    let team: Team

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddPlayersToTeamView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleClub = Team(name: "Sample Club")
        AddPlayersToTeamView(team: sampleClub)
    }
}
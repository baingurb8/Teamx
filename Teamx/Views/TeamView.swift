//
//  TeamView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI

struct TeamView: View {
    let club: Club
    
    var body: some View {
        Text("Teams for \(club.name)") 
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleClub = Club(name: "Sample Club") 
        return TeamView(club: sampleClub)
    }
}

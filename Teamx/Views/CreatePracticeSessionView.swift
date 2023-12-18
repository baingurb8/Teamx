//
//  CreatePracticeSession.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI

struct CreatePracticeSessionView: View {
    let team: Team
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CreatePracticeSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleClub = Team(name: "Sample Club")
        CreatePracticeSessionView(team: sampleClub)
    }
}

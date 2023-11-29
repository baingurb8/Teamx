//
//  PlayerView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI

struct PlayerView: View {
    let userDetails: [String: Any]

    var body: some View {
        VStack {
            Text("Welcome Player")
                .font(.title)
                .padding()
            
          
            Text("Player Name: \(userDetails["firstName"] as? String ?? "")")
                .padding()
        }
    }
}
struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(userDetails: [:])
    }
}

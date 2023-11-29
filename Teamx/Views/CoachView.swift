//
//  CoachView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-29.
//

import SwiftUI

struct CoachView: View {
    let userDetails: [String: Any]

    var body: some View {
        VStack {
            Text("Welcome Coach")
                .font(.title)
                .padding()
            
     
            Text("Coach Name: \(userDetails["firstName"] as? String ?? "")")
                .padding()
        }
    }
}

struct CoachView_Previews: PreviewProvider {
    static var previews: some View {
        CoachView(userDetails: [:])
    }
}

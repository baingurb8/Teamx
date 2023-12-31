//
//  MakeAClubView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-15.
//

import SwiftUI

struct MakeAClubView: View {
    @EnvironmentObject var dbHelper: FireDBHelper
    @Environment(\.dismiss) var dismiss

    @State private var clubName: String = ""

    var body: some View {
        VStack {
            Form {
                TextField("Club Name ", text: self.$clubName)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
            }

            Section {
                Button(action: {
                    // Perform action to save the club to Firestore
                    self.addClub()
                }) {
                    Text("Save Club")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("Make a Club")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addClub() {
        
        let newClub = Club(name: clubName)
        dbHelper.insertClub(stud: newClub)
        dismiss()
    }
}


struct MakeAClubView_Previews: PreviewProvider {
    static var previews: some View {
        MakeAClubView()
    }
}

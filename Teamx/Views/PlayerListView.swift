//
//  PlayersListView.swift
//  Teamx
//
//  Created by Arshdeep Singh on 2023-12-11.
//

import SwiftUI

struct PlayersListView: View {
    @EnvironmentObject var dbHelper: FireDBHelper
    
    @State private var selectedName: Player? = nil
    //@State private var selectedDob: Player? = nil
    //@State private var selectedPosition: Player? = nil
    
    @State private var showingAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            List(self.dbHelper.playersList.enumerated().map({$0}), id: \.element.self ){
                index, teams in
                VStack{
                    Text("Name: \(teams.firstName) \(teams.lastName)")
                        .foregroundColor(.blue)
                        .font(.callout)
                    Text("DOB: \(teams.birthday)")
                        .font(Font.system(size: 14))
                    Text("Position: \(teams.position.rawValue)")
                        .font(Font.system(size: 14))
                }
                .onTapGesture {
                    selectedName = teams
                    showingAlert = true
                }
            }
            Spacer()
        }//VStack
        .alert(isPresented: $showingAlert){
            Alert(title: Text("Add to team?"),
                  message: Text("Would you like to add \(selectedName?.firstName ?? "NA") \(selectedName?.lastName ?? "NA") to the team?"),
                  primaryButton: .default(Text("Yes")){
                    guard let team = selectedName else { return }
                        addToTeams(team)
                    },
                secondaryButton: .cancel(Text("No"))
            )//Alert
        
        }//alert
        
        .navigationBarTitle("Players")
        .onAppear(){
            self.dbHelper.retrieveAllPlayers()
        }
        
    }
    
    func addToTeams(_ team: Player){
        dbHelper.insertTeam(team: team)
    }
}


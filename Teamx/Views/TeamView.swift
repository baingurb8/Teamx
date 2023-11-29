//
//  TeamView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI

struct TeamView: View {
    
    @EnvironmentObject var dbHelper: FireDBHelper
    var body: some View {
        
        VStack{
            ForEach(self.dbHelper.teamList.enumerated().map({$0}), id: \.element.self){
              index, list in
                List{
                    VStack{
                        Text("Team:")
                            .foregroundColor(.blue)
                            .font(.callout)
                        Text("Player Name:)")
                            .font(.callout)
                    }
                }//List
            }//ForEach
        }//VStack
        .onAppear(){
            
            self.dbHelper.retrieveAllTeams()
        }
        .navigationTitle("Clubs")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView()
    }
}

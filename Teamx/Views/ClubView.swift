//
//  ClubView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import SwiftUI

struct ClubView: View {
    
    @EnvironmentObject var dbHelper: FireDBHelper
    
    var body: some View {
        
        VStack{
            ForEach(self.dbHelper.clubList.enumerated().map({$0}), id: \.element.self){
              index, list in
                List{
                    VStack{
                        Text("Club Code:\(list.code)")
                            .foregroundColor(.red)
                        Text("Player Name:\(list.name)")
                    }
                }//List
            }//ForEach
        }//VStack
        .onAppear(){
            
            self.dbHelper.retrieveAllClubs()
        }
        .navigationTitle("Clubs")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct ClubView_Previews: PreviewProvider {
    static var previews: some View {
        ClubView()
    }
}

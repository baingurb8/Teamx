//
//  HealthTipsView.swift
//  Teamx
//
//  Created by Arshdeep Singh on 2023-12-11.
//

import SwiftUI

struct HealthTipsView: View {
    
    @ObservedObject private var healthHelper = HealthHelper()
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                List(healthHelper.healthTips){ index in
                    Text("\(index.title)")
                        .foregroundColor(.blue)
                        .font(.headline)
                    Text("\(index.discription)")
                        .font(.subheadline)
                }
                
            }
            .onAppear{
                //  healthHelper.fetchHealthTips()
            }
            .navigationTitle("Health Tips...")
        }
    }
}


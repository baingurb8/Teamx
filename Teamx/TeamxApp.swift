//
//  TeamxApp.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-08.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct TeamX: App {
    let fireDBHelper : FireDBHelper
    
    init() {
        FirebaseApp.configure()
        fireDBHelper = FireDBHelper.getInstance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(fireDBHelper)
        }
    }
}

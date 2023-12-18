//
//  SettingsView.swift
//  Teamx
//
//  Created by Parth Manchanda on 2023-11-08.
//

import SwiftUI

struct SettingsView: View {
    @State private var rating: Double = 0
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var authManager: AuthenticationHelper

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rate This App")) {
                    NavigationLink(destination: RateAppView(rating: $rating)) {
                        Text("Rate This App")
                    }
                }

                Section(header: Text("Theme Settings")) {
                    Toggle(isOn: Binding(
                        get: { self.themeManager.currentTheme == .dark },
                        set: { self.themeManager.currentTheme = $0 ? .dark : .light }
                    )) {
                        Text("Dark Mode")
                    }
                }

                Section {
                    NavigationLink(destination: DeveloperSettingsView()) {
                        Text("Developer Settings")
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}



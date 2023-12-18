//
//  RateView.swift
//  Teamx
//
//  Created by Parth Manchanda on 2023-12-10.
//

import SwiftUI
import Foundation

struct RateAppView: View {
    @Binding var rating: Double
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            Slider(value: $rating, in: 0...5, step: 0.5)
            HStack {
                ForEach(0..<5) { star in
                    Image(systemName: rating > Double(star) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            Button("Submit Rating") {
                UserDefaults.standard.set(rating, forKey: "appRating")
                showAlert = true
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Thank you!"), message: Text("Rating: \(rating, specifier: "%.1f")"), dismissButton: .default(Text("OK")))
            }
        }
    }
}


struct DeveloperSettingsView: View {
    @State private var enableLogging: Bool = UserDefaults.standard.bool(forKey: "enableLogging")
    @State private var debugMode: Bool = UserDefaults.standard.bool(forKey: "debugMode")
    @State private var selectedEnvironment: String = UserDefaults.standard.string(forKey: "selectedEnvironment") ?? "Production"

    var body: some View {
        Form {
            Toggle("Enable Logging", isOn: $enableLogging)
                .onChange(of: enableLogging) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "enableLogging")
                }

            Toggle("Debug Mode", isOn: $debugMode)
                .onChange(of: debugMode) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "debugMode")
                }

            Picker("Environment", selection: $selectedEnvironment) {
                Text("Production").tag("Production")
                Text("Staging").tag("Staging")
                Text("Development").tag("Development")
            }
            .onChange(of: selectedEnvironment) { newValue in
                UserDefaults.standard.set(newValue, forKey: "selectedEnvironment")
            }
        }
        .navigationBarTitle("Developer Settings")
    }
}

struct DisplaySettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Toggle(isOn: Binding(
            get: { self.themeManager.currentTheme == .dark },
            set: { self.themeManager.currentTheme = $0 ? .dark : .light }
        )) {
            Text("Dark Mode")
        }
        // Add more display settings here
    }
}

struct SaveActionView: View {
    @Binding var rating: Double

    var body: some View {
        VStack {
            Text("Saving rating: \(rating, specifier: "%.1f")")
            Button("Save") {
                // Implement save logic here
                print("Rating saved: \(rating)")
            }
        }
    }
}


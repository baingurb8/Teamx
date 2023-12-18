//
//  ContentView.swift
//  Teamx
//
//  Created by Parth Manchanda on 2023-12-08.
//

import SwiftUI
struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showSettings = false
    
    @State private var showHealthTips = false
    @State private var animateView = false
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedGradientIndex = 0

    let gradient = LinearGradient(
        gradient: Gradient(colors: [Color.pink, Color.white, Color(red: 0.68, green: 0.85, blue: 0.90), Color.blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        
        NavigationView {
            ZStack {
                gradient.edgesIgnoringSafeArea(.all)

                TabView(selection: $selectedTab) {
                                                    LoginView()
                                                        .background(gradient.edgesIgnoringSafeArea(.all))
                                                        .tabItem {
                                                            Label("Login", systemImage: "person.circle.fill")
                                                        }
                                                        .tag(0)
                                                        .transition(.slide)
                                                    MakeAPlayerView()
                                                        .background(gradient.edgesIgnoringSafeArea(.all))
                                                        .tabItem {
                                                            Label("Create Player", systemImage: "person.fill")
                                                        }
                                                        .tag(1)
                                                        .transition(.slide)
                                                    CreateACoachView()
                                                        .background(gradient.edgesIgnoringSafeArea(.all))
                                                        .tabItem {
                                                            Label("Create Coach", systemImage: "person.3.fill")
                                                        }
                                                        .tag(2)
                                                        .transition(.slide)
                                                    NewsListView()
                                                        .background(gradient.edgesIgnoringSafeArea(.all))
                                                        .tabItem {
                                                            Label("News", systemImage: "newspaper.fill")
                                                        }
                                                        .tag(3)
                                                        .transition(.slide)
                                                }
                .animation(.easeInOut, value: selectedTab)

                if showSettings {
                    SettingsView()
                        .background(gradient.edgesIgnoringSafeArea(.all))
                        .scaleEffect(animateView ? 1 : 0.1)
                        .rotationEffect(.degrees(animateView ? 0 : 360))
                        .opacity(animateView ? 1 : 0)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.scale)
                }

                if showHealthTips {
                    HealthTipsView()
                        .background(gradient.edgesIgnoringSafeArea(.all))
                        .scaleEffect(animateView ? 1 : 0.1)
                        .rotationEffect(.degrees(animateView ? 0 : 360))
                        .opacity(animateView ? 1 : 0)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.scale)
                }
            }
            .navigationBarTitle("TeamX")
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        withAnimation {
                            showHealthTips.toggle()
                            showSettings = false
                            animateView = showHealthTips
                        }
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        withAnimation {
                            showSettings.toggle()
                            showHealthTips = false
                            animateView = showSettings
                        }
                    }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ThemeManager())
    }
}


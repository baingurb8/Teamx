//
//  CoachView.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-29.
//

import SwiftUI

import SwiftUI
import CoreLocation


struct CoachView: View {
    let userDetails: [String: Any]
    @EnvironmentObject var weatherHelper: WeatherHelper
    @EnvironmentObject var locationHelper: LocationHelper
    
    @State private var currentLocation: CLLocation?

    var body: some View {
        
        NavigationView{
            
            VStack {
                Text("Welcome Coach")
                    .font(.title)
                    .padding()
                
                Text("Coach Name: \(userDetails["firstName"] as? String ?? "")")
                    .padding()
                
                if let weatherInfo = weatherHelper.weatherInfo { // Check if weatherInfo is available
                    Text("Weather Info")
                        .font(.title)
                        .padding()
                    VStack{
                        Text("Location: \(weatherInfo.cityName)")
                            .font(.headline)
                        Text(String(format: "Temperature: %.2f°C", weatherInfo.tempC))
                        Text(String(format: "Feels Like: %.2f°C", weatherInfo.feelsLikeC))
                        Text("Condition: \(weatherInfo.condition)")
                        Text("Wind: \(weatherInfo.windDir), \(String(format: "%.2f KPH", weatherInfo.windKph))")
                        Text("Humidity: \(weatherInfo.humidity)%")
                    }
                    .background(Color.gray)
                    .cornerRadius(5)
                    .padding()
                    
                    
                } else {
                    Text("Fetching weather information...")
                        .foregroundColor(.gray)
                }
                
                HStack{
                    NavigationLink(destination: ClubView()){
                        Text("Clubs")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                        
                    NavigationLink(destination: TeamView()){
                            Text("Teams")
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                            
                            
                    }
                        
                }//HStack
                
            }//VStack
        }// NavigationLink
        .onAppear {
            if let location = locationHelper.currentLocation {
                weatherHelper.fetchDataFromAPI(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
        }
        .onChange(of: locationHelper.currentLocation) { newLocation in
            if let location = newLocation {
                weatherHelper.fetchDataFromAPI(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.currentLocation = location
            }
        }
    }
}

struct CoachView_Previews: PreviewProvider {
    static var previews: some View {
        CoachView(userDetails: [:])
    }
}

// from coach go to my teams view where coach can see all the players


//
//  CoachView.swift
//  Teamx
//
//  Created by Arshdeep Singh on 2023-11-29.
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
            VStack(alignment: .leading) {
                Text("Welcome, \(userDetails["firstName"] as? String ?? "")")
                    .font(.title)
                    .padding()
                
                Text("")
                    .font(.title2)
                    .padding()
                VStack{
                    if let weatherInfo = weatherHelper.weatherInfo { // Check if weatherInfo is available
                        Text("Today's weather")
                            .font(.title)
                        VStack{
                            //Text("Location: \(weatherInfo.cityName)")
                            //    .font(.headline)
                            Text(String(format: "%.2f°C", weatherInfo.tempC))
                                .font(.title)
                                .bold()
                                .foregroundColor(.blue)
                            Text(String(format: "Feels Like: %.2f°C", weatherInfo.feelsLikeC))
                                .font(.headline)
                            Text("Condition: \(weatherInfo.condition)")
                                .font(.headline)
                            Text("Wind: \(weatherInfo.windDir), \(String(format: "%.2f KPH", weatherInfo.windKph))")
                                .font(.headline)
                            Text("Humidity: \(weatherInfo.humidity)%")
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                    
                    } else {
                        Text("Fetching weather information...")
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    HStack{
                        NavigationLink(destination: PlayersListView()) {
                            Text("Players")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        
                        NavigationLink(destination: CoachClubView(userDetails: userDetails)) {
                            Text("Clubs")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        
//                        NavigationLink(destination: TeamView()) {
//                            Text("Teams")
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(15)
//                        }
                        
                    }//HStack
                    .padding()
                }//VStack
            }//VStack
        }.navigationBarBackButtonHidden(true)//NavigationView
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

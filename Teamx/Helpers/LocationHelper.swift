//
//  LocationHelper.swift
//  Teamx
//
//  Created by Gurbir Bains on 2023-11-22.
//

import Foundation
import CoreLocation

class LocationHelper : NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var currentLocation : CLLocation?
    
    private let locationManager = CLLocationManager()
    private let geoCoder = CLGeocoder()
    var weatherHelper = WeatherHelper()
    
    override init(){
        super.init()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
            
        case .authorizedAlways:
            print(#function, "Always access granted for location")
            manager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            print(#function, "Foreground access granted for location")
            manager.startUpdatingLocation()
            
        case .notDetermined, .denied:
            print(#function, "location permission : \(manager.authorizationStatus)")
            
           
            manager.stopUpdatingLocation()
            
            manager.requestWhenInUseAuthorization()
            
            
        case .restricted:
            print(#function, "location permission restricted")
            
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
            
        @unknown default:
                print(#function, "location permission not received")
            
               
                manager.stopUpdatingLocation()
                
                manager.requestWhenInUseAuthorization()
                    }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print(#function, "Most recent location : \(location.coordinate)")
            
            self.currentLocation = location
            weatherHelper.fetchDataFromAPI(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        } else {
            print(#function, "No location received")
        }
        print(#function, "current location : \(self.currentLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Unable to receive location changes due to error : \(error)")
       
    }
    
}


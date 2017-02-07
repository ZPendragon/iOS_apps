//
//  LocationRequestManager.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/6/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//
/*
import Foundation
import CoreLocation

enum LocationResponse {
    case success(location: [CLPlacemark])
    case failure(error: Error)
}

final class LocationRequestManager {
    
    // Mark: - Singleton
    
    struct Static {
        static let instance = LocationRequestManager()
    }
    static var sharedInstance: LocationRequestManager {
        return Static.instance
    }
    
    // Mark: - Properties
    
    let locationManager = CLLocationManager()
    
    
    // Mark: - Private Methods
    
    fileprivate func makeRequestForLocation(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation], completion: @escaping (LocationResponse) -> Void) {
        
        // These 4 commands need to go in a seperate kick-off function
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
   
        
        let userLocation: CLLocation = locations[0]
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error)-> Void in
            
            let placemark: CLPlacemark!
            if (error == nil && placemarks!.count > 0) {
                placemark = placemarks![0] as CLPlacemark
                if placemark.isoCountryCode == "US" {
                    if placemark.locality != nil {
                        self.cityTextField.text = placemark.locality!
                    }
                    if placemark.administrativeArea != nil {
    
                        self.cityTextField.text = self.cityTextField.text! + "," + placemark.administrativeArea!
                    }
                    
                    self.checkValidCityName()
                    
                    UIView.animate(withDuration: 1.5, animations: { () -> Void in
                        
                        self.cityTextField.alpha = 1
                        self.getWeatherBtn.alpha = 1
                        
                    })
                    //                    if placemark.postalCode != nil {
                    //                        //print("Zip " + placemark.postalCode!)
                    //                        self.addressLabel.text = self.addressLabel.text! + ", " + placemark.postalCode!
                    //                    }
                    /*if placemark.country != nil {
                     print("Country " + placemark.country!)
                     //self.addressLabel.text = placemark.country
                     }*/
                    
                    /* if placemark.subAdministrativeArea != nil {
                     print(placemark.subAdministrativeArea!)
                     //self.addressLabel.text = placemark.country
                     } */
                    
                    
                }
            }
        })
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - Public Methods
    
}
 */

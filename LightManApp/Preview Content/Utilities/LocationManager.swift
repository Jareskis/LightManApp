//
//  LocationManager.swift
//  LightManApp
//
//  Created by Jarek Carlson on 7/10/26.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    static func geocode(street: String, city: String, state: String, zip: String, completion: @escaping (Double?, Double?) -> Void){
        let fullAddress = "\(street), \(city), \(state), \(zip)"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(fullAddress){ placemarks, error in //Here are my parameters(placemarks, error), do this with them
            if let error = error {
                print("\(error.localizedDescription)")
            }
            if let placemark = placemarks?.first,
               let location = placemark.location {
                completion(location.coordinate.latitude, location.coordinate.longitude)
            } else  {
                completion(nil, nil)
            }
        }
    }
    
}

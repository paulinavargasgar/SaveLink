//
//  GeoCoderHelper.swift
//  SaveLink
//
//  Created by Adrián Reyes on 15/11/24.
//

import CoreLocation

struct GeocoderHelper {
    static func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Error en geocodificación: \(error)")
                completion(nil)
            } else if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                completion(nil)
            }
        }
    }
}

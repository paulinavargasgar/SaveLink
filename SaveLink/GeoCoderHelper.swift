//
//  GeoCoderHelper.swift
//  SaveLink
//
//  Created by Adrián Reyes on 15/11/24.
//

import CoreLocation

struct GeocoderHelper {
    private static var processedAddresses = Set<String>() // Para evitar geocodificar duplicados
    
    
    
    static func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        // Verificar si la dirección ya fue procesada
        guard !processedAddresses.contains(address) else {
            print("Dirección ya procesada, ignorando: \(address)")
            completion(nil)
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Error en geocodificación: \(error)")
                completion(nil)
            } else if let placemark = placemarks?.first, let location = placemark.location {
                // Almacenar la dirección como procesada
                processedAddresses.insert(address)
                completion(location.coordinate)
            } else {
                completion(nil)
            }
        }
    }
}



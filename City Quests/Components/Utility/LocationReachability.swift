//
//  LocationReachability.swift
//  Boom
//
//  Created by mac on 26/02/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation

import CoreLocation

open class LocationReachability {
    
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
}

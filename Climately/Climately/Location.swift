//
//  Location.swift
//  Climately
//
//  Created by Kevin Zeckser on 2/6/17.
//  Copyright © 2017 Kevin Zeckser. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
    
    let city:       String
    let state:      String
    
    init?(fromPlacemark placemark: CLPlacemark) {
        guard let city = placemark.locality! as String?,
            let state = placemark.administrativeArea! as String? else {return nil}
        
        self.city = city
        self.state = state
    }
    
    
}

//
//  MapPin.swift
//  Rekola
//
//  Created by Daniel Brezina on 30/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation {
    let title: String
    let subtitle: String
    let coordinate: CLLocationCoordinate2D
    let iconUrl: String
    
    init(bike: Bike) {
        self.title = bike.name
        self.subtitle = bike.description
        let coord = CLLocationCoordinate2DMake(bike.location.lat, bike.location.lng)
        self.iconUrl = bike.iconUrl
        self.coordinate = coord
        
        super.init()
    }
}
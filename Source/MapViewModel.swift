//
//  MapViewModel.swift
//  Rekola
//
//  Created by Dominik Vesely on 19/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import ReactiveCocoa

class MapViewModel : NSObject {
    
    let bikes = MutableProperty<[Bike]?>(nil)
    
    let selectedBike = MutableProperty<Bike?>(nil)
    
    
    
}
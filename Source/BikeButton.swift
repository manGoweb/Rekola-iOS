//
//  BikeButton.swift
//  Rekola
//
//  Created by Daniel Brezina on 18/08/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class BikeButton: UIButton {

    weak var bikeImageView: UIImageView!
    var bike: Bike
    
    init(imageView: UIImageView, bike: Bike) {
        self.bikeImageView = imageView
        self.bike = bike
        super.init(frame: CGRectZero)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

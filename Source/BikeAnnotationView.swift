//
//  BikeAnnotationView.swift
//  Rekola
//
//  Created by Daniel Brezina on 06/08/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import MapKit

class BikeAnnotationView: MKAnnotationView {
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        let backgroundImage = UIImageView(image: UIImage(imageIdentifier: .MapPinGreen))
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



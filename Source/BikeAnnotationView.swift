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
    weak var backgroundImageView: UIImageView!
    weak var bikeImageView: UIImageView! = UIImageView()
    
    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRectMake(0, 0, 44, 42)
        
        let backgroundImageView = UIImageView(/*image: UIImage(imageIdentifier: .MapPinGreen)*/)
        addSubview(backgroundImageView)
        backgroundImageView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
        self.backgroundImageView = backgroundImageView
        
        
        let bikeImageView = UIImageView()
        backgroundImageView.addSubview(bikeImageView)
        bikeImageView.contentMode = .ScaleAspectFit
        bikeImageView.snp_makeConstraints { make in
            make.top.equalTo(backgroundImageView).offset(6)
            make.left.equalTo(backgroundImageView).offset(6)
            make.right.equalTo(backgroundImageView).offset(-6)
            make.bottom.equalTo(backgroundImageView).offset(-16)
        }
        self.bikeImageView = bikeImageView
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}



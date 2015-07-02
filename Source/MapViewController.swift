//
//  MapViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 29/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import ReactiveCocoa


class MapViewController: UIViewController, MKMapViewDelegate {
    
    override func loadView() {
        
        let view = UIView()
        self.view = view
        
        let map = MKMapView()
        view.addSubview(map)
        map.snp_makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }
        self.mapView = map
    }
    
    weak var detailView: UIView!
    weak var container: UIView!
    weak var mapView: MKMapView!
    var bikes: [Bike]?
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = .whiteColor()
        

        mapView.delegate = self
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        
        let producer = API.login("josef.gattermayer@ackee.cz", password: "AckeeTest") |> then(API.bikes(49, longitude: 14))
        producer.start(error: { println($0) }, next: { [weak self] (bikes : [Bike]) in
            self?.bikes = bikes
            //            asynchronni volani bude
            })
        
        if let nearBikes = bikes {
            for bike in nearBikes {
                let mapPin = MapPin(bike: bike)
                mapView.addAnnotation(mapPin)
            }
        } else {
            let myBike = Bike.myBike()
            let mapPin = MapPin(bike: myBike)
            mapView.addAnnotation(mapPin)
        }
    }
    
//    check this
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? MapPin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
                    let url = NSURL(string: annotation.iconUrl)
                    let imageData = NSData(contentsOfURL: url!)
                    view.image = UIImage(data: imageData!)
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                let url = NSURL(string: annotation.iconUrl)
                let imageData = NSData(contentsOfURL: url!)
                view.image = UIImage(data: imageData!)
            }
            return view
        }
        return nil
    }}

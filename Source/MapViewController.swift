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
        
        let detailView = UIView()
        view.addSubview(detailView)
        detailView.backgroundColor = .rekolaPinkColor()
        detailView.opaque = true
        detailView.alpha = 0
        detailView.snp_makeConstraints { make in
            make.height.equalTo(192)
            make.top.equalTo(view)
            make.left.right.equalTo(view)
        }
        self.detailView = detailView
        
        let bikeImage = UIImageView(image: UIImage(imageIdentifier: .bike))
        detailView.addSubview(bikeImage)
        bikeImage.snp_makeConstraints { make in
            make.top.equalTo(view).offset(70)
            make.left.equalTo(view).offset(L.horizontalSpacing)
        }
        self.bikeImage = bikeImage
        
        let nameLabel = Theme.whiteLabel()
        nameLabel.font = UIFont.boldSystemFontOfSize(17)
        detailView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(view).offset(70)
            make.left.equalTo(bikeImage.snp_right)
            
        }
        self.bikeNameLabel = nameLabel
        
        let distanceLabel = Theme.whiteLabel()
        distanceLabel.font = UIFont.italicSystemFontOfSize(16)
        detailView.addSubview(distanceLabel)
        distanceLabel.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottom)
            make.left.equalTo(bikeImage.snp_right)
        }
        self.bikeDistanceLabel = distanceLabel
        
        let descriptionLabel = Theme.whiteLabel()
        descriptionLabel.font = UIFont.boldSystemFontOfSize(15)
        descriptionLabel.numberOfLines = 0
        detailView.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(distanceLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(bikeImage.snp_right)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.bikeDescriptionLabel = descriptionLabel
        
        let noteLabel = Theme.whiteLabel()
        noteLabel.font = UIFont.systemFontOfSize(15)
        noteLabel.numberOfLines = 0
        detailView.addSubview(noteLabel)
        noteLabel.snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(bikeImage.snp_right)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.bikeNoteLabel = noteLabel
        
    }
    
    weak var detailView: UIView!
    weak var container: UIView!
    weak var mapView: MKMapView!
    weak var navItem: UINavigationItem!
    weak var bikeNameLabel: UILabel!
    weak var bikeDescriptionLabel: UILabel!
    weak var bikeDistanceLabel: UILabel!
    weak var bikeNoteLabel: UILabel!
    weak var bikeImage: UIImageView!
    var bikes: [Bike]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationBar settings + tintColor
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationItem.title = "Mapa"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        self.navigationController?.navigationBar.barTintColor = .rekolaPinkColor()
        
        let leftBarButton = UIBarButtonItem(image: UIImage(imageIdentifier: .directionButton), style:.Plain, target: self, action: "leftBarButtonClicked")
        let rightBarButton = UIBarButtonItem(image: UIImage(imageIdentifier: .locationButton), style: .Plain, target: self, action: "rightBarButtonClicked")
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
//        mapView settings
        mapView.delegate = self
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        
//        API calling
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
//    this needs to be repaired with API
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
            }
            return view
        }
        return nil
    }
    
//    MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        self.detailView.alpha = 1.0
        self.navigationController?.navigationBarHidden = false
        
//        following text will be replaced with text from API
        self.bikeImage.contentMode = UIViewContentMode.ScaleAspectFit
        self.bikeNameLabel.text = "Pivoňka"
        self.bikeDistanceLabel.text = "850 m"
        self.bikeDescriptionLabel.text = "Pod železničním mostem na dohled od Tesca"
        self.bikeNoteLabel.text = "Koloběžka bez zbytečností"
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        self.detailView.alpha = 0.0
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

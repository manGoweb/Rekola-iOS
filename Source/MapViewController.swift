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


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
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
        detailView.snp_makeConstraints { make in
            //            make.height.equalTo(192 - 64)
            make.top.equalTo(view)
            make.left.right.equalTo(view)
        }
        self.detailView = detailView
        
        let bikeImage = UIImageView(/*image: UIImage(imageIdentifier: .bike)*/)
        detailView.addSubview(bikeImage)
        bikeImage.contentMode = .ScaleAspectFit
        bikeImage.setContentHuggingPriority(1000, forAxis: .Horizontal)
        bikeImage.snp_makeConstraints { make in
            make.top.equalTo(view).offset(70 - 64)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.width.equalTo(44)
            make.height.equalTo(33)
        }
        self.bikeImage = bikeImage
        
        let nameLabel = Theme.whiteLabel()
        detailView.addSubview(nameLabel)
        nameLabel.font = UIFont.boldSystemFontOfSize(17)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(view).offset(70 - 64)
            make.left.equalTo(bikeImage.snp_right).offset(L.horizontalSpacing)
            
        }
        self.bikeNameLabel = nameLabel
        
        let distanceLabel = Theme.whiteLabel()
        detailView.addSubview(distanceLabel)
        distanceLabel.font = UIFont.italicSystemFontOfSize(16)
        distanceLabel.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottom)
            make.left.equalTo(bikeImage.snp_right).offset(L.horizontalSpacing)
        }
        self.bikeDistanceLabel = distanceLabel
        
        let noteLabel = Theme.whiteLabel()
        detailView.addSubview(noteLabel)
        noteLabel.font = UIFont.boldSystemFontOfSize(15)
        noteLabel.numberOfLines = 0
        noteLabel.snp_makeConstraints { make in
            make.top.equalTo(distanceLabel.snp_bottom).offset(10)
            make.left.equalTo(bikeImage.snp_right).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.bikeNoteLabel = noteLabel
        
        let descriptionLabel = Theme.whiteLabel()
        detailView.addSubview(descriptionLabel)
        descriptionLabel.font = UIFont.systemFontOfSize(15)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .rekolaLightPinkColor()
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(noteLabel.snp_bottom).offset(10)
            make.left.equalTo(bikeImage.snp_right).offset(L.horizontalSpacing)
            make.right.bottom.equalTo(detailView).inset(L.contentInsets)
        }
        self.bikeDescriptionLabel = descriptionLabel
    }
    
    weak var detailView: UIView!
    weak var container: UIView!
    weak var mapView: MKMapView!
    weak var navItem: UINavigationItem! //WTF?
    weak var bikeNameLabel: UILabel!
    weak var bikeDescriptionLabel: UILabel!
    weak var bikeDistanceLabel: UILabel!
    weak var bikeNoteLabel: UILabel!
    weak var bikeImage: UIImageView!
    var bikes: [Bike] = [] {
        didSet {
            var bikesMapPin: [MapPin] = []
            for bike in bikes {
                let bikeMapPin = MapPin(bike: bike)
                bikesMapPin.append(bikeMapPin)
            }
            mapView.addAnnotations(bikesMapPin)
        }
    }
    let locationManager = CLLocationManager()
    var bikeCoordinate = CLLocationCoordinate2D()
    var usersCoordinate = CLLocationCoordinate2D(latitude: 50.079167, longitude: 14.428414) //default coordinate
    var boundaries = Boundaries(regions: [], zones: [])
    var coordForBoundaries: [[CLLocationCoordinate2D]] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        navigationBar settings + tintColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationItem.title = NSLocalizedString("MAP_title", comment: "")
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        navigationController?.navigationBar.barTintColor = .rekolaPinkColor()
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.translucent = false
        
        let leftBarButton = UIBarButtonItem(image: UIImage(imageIdentifier: .directionButton), style:.Plain, target: self, action: "showDirections")
        navigationItem.leftBarButtonItem = leftBarButton
        
        //        mapView settings
        mapView.delegate = self
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.showsUserLocation = true
        
        //        detailView setting
        detailView.hidden = true
        
        //        locationManager settings
        locationManager.delegate = self
        locationManager(locationManager, didChangeAuthorizationStatus: CLLocationManager.authorizationStatus())
        locationManager.requestWhenInUseAuthorization()
        
        //        set users coordinate and calling API
        
        if locationManager.location != nil {
            usersCoordinate = locationManager.location.coordinate
            loadBikes(usersCoordinate) //calling API with usersCoordinate
        } else {
            loadBikes(usersCoordinate) //calling API with default coordinate
        }
        loadBoundaries()
        //        parseBoundaries(boundaries)
    }
    
    let bikesRequestPending = MutableProperty(false)
    func loadBikes(coordinate: CLLocationCoordinate2D) {
        bikesRequestPending.value = false
        API.bikes(latitude: coordinate.latitude, longitude: coordinate.longitude).start(error: { error in
            self.handleError(error)
            },next: {
                self.bikes = $0
        })
    }
    
    let boundariesRequestPending = MutableProperty(false)
    func loadBoundaries() {
        boundariesRequestPending.value = false
        API.getBoundaries().start(error: { error in
            self.handleError(error)
            }, next: {
                self.boundaries = $0
                self.parseBoundaries(self.boundaries)
        })
    }
    
    func showDirections() {
        let placemark = MKPlacemark(coordinate: bikeCoordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
    func showLocations() {
        mapView.setCenterCoordinate(mapView.userLocation.location.coordinate, animated: true)
    }
    
    func drawPolygon(var coords: [[CLLocationCoordinate2D]]) {
        for zones in coords {
            var tmpArray = zones
            var polyline = MKPolyline(coordinates: &tmpArray, count: zones.count)
            mapView.addOverlay(polyline, level: MKOverlayLevel.AboveLabels)
            //            mapView.addOverlay(polyline)
        }
    }
    
    func parseBoundaries(boundaries: Boundaries) {
        for zones in boundaries.zones {
            let myString = zones.coords
            let myCoordsString = split(myString, maxSplit: Int.max, allowEmptySlices: false, isSeparator: {$0 == ";"})
            let doublesCoord = myCoordsString.map({ doubles -> CLLocationCoordinate2D in
                let lanAndLon = split(doubles, maxSplit: Int.max, allowEmptySlices: false, isSeparator: {$0 == ","})
                let lan = (lanAndLon[1] as NSString).doubleValue
                let lot = (lanAndLon[0] as NSString).doubleValue
                return CLLocationCoordinate2D(latitude: lan, longitude: lot)
            })
            self.coordForBoundaries.append(doublesCoord)
            
        }
        
        self.drawPolygon(self.coordForBoundaries)
    }
    
    //    MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? MapPin {
            let identifier = "pin"
            
            let url = NSURL(string: annotation.iconUrl)
            
            var view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? BikeAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? BikeAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = BikeAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            
            view?.backgroundImageView.image = UIImage(imageIdentifier: .MapPinPink)
            view?.bikeImageView.sd_setImageWithURL(url)
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .rekolaPinkColor()
            polylineRenderer.fillColor = UIColor(red: 253, green: 52, blue: 156, alpha: 1.0)
            polylineRenderer.lineWidth = 6
            return polylineRenderer
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        self.detailView.hidden = false
        
        mapView.setCenterCoordinate(view.annotation.coordinate, animated: true)
        bikeCoordinate = view.annotation.coordinate
        
        let bikeAnnotation = view.annotation as! MapPin
        let url = NSURL(string: bikeAnnotation.iconUrl)
        
        self.bikeImage.sd_setImageWithURL(url)
        self.bikeNameLabel.text = bikeAnnotation.title
        self.bikeDistanceLabel.text = bikeAnnotation.distance
        self.bikeDescriptionLabel.text = bikeAnnotation.bikeDescription
        self.bikeNoteLabel.text = bikeAnnotation.bikeLocationNote
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        self.detailView.hidden = true
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            mapView.showsUserLocation = true
            navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        default:
            mapView.showsUserLocation = false
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let placemark = MKPlacemark(coordinate: view.annotation.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
}



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
import CoreLocation


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
        
//        let bikeButton = UIButton()
//        detailView.addSubview(bikeButton)
//        bikeButton.imageView?.contentMode = .ScaleAspectFit
//        bikeButton.setContentHuggingPriority(1000, forAxis: .Horizontal)
//        bikeButton.snp_makeConstraints { make in
//            make.top.equalTo(view).offset(70-64)
//            make.left.equalTo(view).offset(L.horizontalSpacing)
//            make.width.equalTo(44)
//            make.height.equalTo(33)
//        }
//        self.bikeButton = bikeButton
        
        let nameLabel = Theme.whiteLabel()
        detailView.addSubview(nameLabel)
        nameLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 18)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(view).offset(70 - 64)
            make.left.equalTo(bikeImage.snp_right).offset(L.horizontalSpacing)
            
        }
        self.bikeNameLabel = nameLabel
        
        let distanceLabel = Theme.whiteLabel()
        detailView.addSubview(distanceLabel)
        distanceLabel.font = UIFont(name: Theme.SFFont.Italic.rawValue, size: 16)
        distanceLabel.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottom)
            make.left.equalTo(bikeImage.snp_right).offset(L.horizontalSpacing)
        }
        self.bikeDistanceLabel = distanceLabel
        
        let noteLabel = Theme.whiteLabel()
        detailView.addSubview(noteLabel)
        noteLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 15)
        noteLabel.numberOfLines = 0
        noteLabel.snp_makeConstraints { make in
            make.top.equalTo(distanceLabel.snp_bottom).offset(10)
            make.left.equalTo(bikeImage.snp_right).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.bikeNoteLabel = noteLabel
        
        let descriptionLabel = Theme.whiteLabel()
        detailView.addSubview(descriptionLabel)
        descriptionLabel.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 15)
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
    weak var bikeNameLabel: UILabel!
    weak var bikeDescriptionLabel: UILabel!
    weak var bikeDistanceLabel: UILabel!
    weak var bikeNoteLabel: UILabel!
    weak var bikeImage: UIImageView!
    weak var bikeButton: UIButton!
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
    var isFirstTimeAuthorization = true
    var bikeCoordinate = CLLocationCoordinate2D()
    var usersCoordinate = CLLocationCoordinate2D(latitude: 50.079167, longitude: 14.428414) //default coordinate
    var boundaries = Boundaries(regions: [], zones: [])
    var coordForBoundaries: [[CLLocationCoordinate2D]] = []
    var sendingBike = Bike?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
//        navigationBar settings + tintColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationItem.title = NSLocalizedString("MAP_title", comment: "")
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
//        navigationController?.navigationBar.barTintColor = .rekolaPinkColor()
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

        
// calling API
        loadBoundaries()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.barTintColor = .rekolaPinkColor()
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        deleteLineUnderNavBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = .whiteColor()
        self.navigationController?.navigationBar.tintColor = .rekolaPinkColor()
        
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    func deleteLineUnderNavBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
    }
    
//    API calling
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
    
    func showBikeDetail(sender: AnyObject?) {
        if sender is UIButton {
            if let bikeDetail = sendingBike {
                let vc = BikeDetailViewController(bike: bikeDetail)
                showViewController(vc, sender: sender)
            }
        }
    }
    
    func drawPolygon(var coords: [[CLLocationCoordinate2D]]) {
        for zones in coords {
            var tmpArray = zones
            var polygon = MKPolygon(coordinates: &tmpArray, count: zones.count)
            mapView.addOverlay(polygon, level: MKOverlayLevel.AboveLabels)
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
    
//    MARK: CLlocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if isFirstTimeAuthorization {
            switch status {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                mapView.showsUserLocation = true
                navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
                usersCoordinate = locationManager.location.coordinate
                loadBikes(usersCoordinate) //calling API with usersCoordinate
                
            default:
                mapView.showsUserLocation = false
                navigationItem.rightBarButtonItem = nil
                loadBikes(usersCoordinate) //calling API with default coordinate
            }
        }
        isFirstTimeAuthorization = false
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let userLocation = manager.location
        let zoomLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)

        let visible: CLLocationDistance = 1000

        let region = MKCoordinateRegionMakeWithDistance(zoomLocation, visible, visible)
        mapView.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
    
    //    MARK: MKMapViewDelegate
//    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        let zoomLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        
//        let visible: CLLocationDistance = 1000
//        
//        let region = MKCoordinateRegionMakeWithDistance(zoomLocation, visible, visible)
//        mapView.setRegion(region, animated: true)
//        
//    }
    
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
            
            view?.backgroundImageView.image = UIImage(imageIdentifier: .MapPinGreen)
            view?.bikeImageView.sd_setImageWithURL(url)
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {

        if overlay is MKPolygon {
            var polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.strokeColor = .rekolaPinkColor()
            polygonRenderer.fillColor = UIColor.rekolaPinkColor().colorWithAlphaComponent(0.1)
            polygonRenderer.lineWidth = 6
            return polygonRenderer
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if view.annotation is MapPin {
            self.detailView.hidden = false
            
            let mapPin = view as! BikeAnnotationView
            mapPin.backgroundImageView.image = UIImage(imageIdentifier: .MapPinPink)
            
            
            mapView.setCenterCoordinate(view.annotation.coordinate, animated: true)
            bikeCoordinate = view.annotation.coordinate
            
            let bikeAnnotation = view.annotation as! MapPin
            let url = NSURL(string: bikeAnnotation.iconUrl)
            
            bikeImage.sd_setImageWithURL(url)
            sendingBike = bikeAnnotation.bike
            
            bikeNameLabel.text = bikeAnnotation.title
            bikeDistanceLabel.text = bikeAnnotation.distance
            
            detailView.onTap{[weak self] (sender: AnyObject!) in
                if let bikeDetail = self?.sendingBike {
                    let vc = BikeDetailViewController(bike: bikeDetail)
                    self?.showViewController(vc, sender: sender)
                }
            }
            
            if bikeAnnotation.bikeLocationNote!.isEmpty {
                bikeNoteLabel.hidden = true
                bikeDescriptionLabel.snp_remakeConstraints{ make in
                    make.top.equalTo(bikeDistanceLabel.snp_bottom).offset(10)
                    make.left.equalTo(bikeImage.snp_right).offset(L.horizontalSpacing)
                    make.right.bottom.equalTo(detailView).offset(-L.horizontalSpacing)
                }
                detailView.setNeedsLayout()
            } else {
                bikeNoteLabel.text = bikeAnnotation.bikeLocationNote
            }
            bikeDescriptionLabel.text = bikeAnnotation.bikeDescription
        }
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        if view.annotation is MapPin {
            let mapPinView = view as! BikeAnnotationView
            mapPinView.backgroundImageView.image = UIImage(imageIdentifier: .MapPinGreen)
            
            let bikeAnnotation = view.annotation as! MapPin
            
            if bikeAnnotation.bikeLocationNote!.isEmpty {
                bikeNoteLabel.hidden = false
                bikeDescriptionLabel.snp_remakeConstraints{ make in
                    make.top.equalTo(bikeNoteLabel.snp_bottom).offset(10)
                    make.left.equalTo(bikeImage.snp_right).offset(L.horizontalSpacing)
                    make.right.bottom.equalTo(detailView).offset(-L.horizontalSpacing)
                }
                detailView.setNeedsLayout()
            }
            
            detailView.hidden = true
        }
    }

    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let placemark = MKPlacemark(coordinate: view.annotation.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
}



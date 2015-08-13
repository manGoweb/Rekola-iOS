//
//  ReturnBikeViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 08/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import MapKit
import CoreLocation
import ReactiveCocoa

class ReturnBikeViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate{
	
	let bike : Bike
	init(bike: Bike) {
		self.bike = bike
		super.init(nibName:nil, bundle:nil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
 
	override func loadView() {
        let view = UIView()
        view.backgroundColor = .whiteColor()
        self.view = view
        
        setupKeyboardLayoutGuide()
        
        let returnButton = Theme.pinkButton()
        view.addSubview(returnButton)
        returnButton.snp_makeConstraints { make in
            make.bottom.equalTo(view).offset(-L.verticalSpacing).priorityLow()
            make.height.equalTo(44)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.returnButton = returnButton
        
        let textView = SZTextView()
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 4
        textView.textColor = .grayColor()
        textView.returnKeyType = .Done
        textView.setContentCompressionResistancePriority(740, forAxis: .Vertical)
        view.addSubview(textView)
        textView.snp_makeConstraints { make in
            make.bottom.equalTo(returnButton.snp_top).offset(-L.horizontalSpacing)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.height.equalTo(72)
            make.bottom.lessThanOrEqualTo(keyboardLayoutGuide)
        }
        self.textView = textView
        
        let descriptionLabel = UILabel()
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = UIColor.rekolaBlackColor()
        descriptionLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 17)
        descriptionLabel.snp_makeConstraints { make in
            make.bottom.equalTo(textView.snp_top).offset(-L.verticalSpacing)
            make.right.left.equalTo(view).offset(L.horizontalSpacing)
        }
        self.descriptionLabel = descriptionLabel
        
        let mapView = MKMapView()
        view.addSubview(mapView)
        mapView.snp_makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp_top).offset(-L.verticalSpacing)
            make.left.right.equalTo(view)
			make.top.equalTo(snp_topLayoutGuideBottom)
        }
        self.mapView = mapView
		
		let pinImageView = UIImageView(image: UIImage(imageIdentifier: .BikeMapPinPink))
		view.addSubview(pinImageView)
		pinImageView.snp_makeConstraints { make in
			make.centerX.equalTo(mapView)
			make.bottom.equalTo(mapView.snp_centerY)
		}
		self.pinImageView = pinImageView
    }

    weak var mapView: MKMapView!
	weak var pinImageView : UIImageView!
    weak var returnButton: UIButton!
    weak var textView: SZTextView!
    weak var descriptionLabel: UILabel!
    let locationManager = CLLocationManager()
    var boundaries = Boundaries(regions: [], zones: [])
    var coordForBoundaries: [[CLLocationCoordinate2D]] = []

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        navigationController?.navigationBar.barTintColor = .rekolaGreenColor()
        navigationController?.navigationBar.tintColor = .whiteColor()
        navigationItem.title = NSLocalizedString("RETURNBIKE_title", comment: "")
        
        descriptionLabel.text = NSLocalizedString("RETURNBIKE_description", comment: "")
        descriptionLabel.textAlignment = .Left

        
        textView.delegate = self
		textView.placeholder = NSLocalizedString("RETURN_PLACEHOLDER", comment: "")
        textView.textColor = .grayColor()
        textView.editable = true
        
        self.returnButton.setTitle(NSLocalizedString("RETURNBIKE_return" , comment: ""), forState: .Normal)
        
        mapView.delegate = self
        mapView.scrollEnabled = true
        mapView.zoomEnabled = true
        mapView.showsUserLocation = true
		
		navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
		
		returnButton.addTarget(self, action: "returnBike:", forControlEvents: .TouchUpInside)
		returnButton.rac_enabled <~ requestPending.producer |> map { !$0 }
        
        loadBoundaries()
    }
	
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    
    
	var mapLocation : CLLocationCoordinate2D {
		return mapView.centerCoordinate
	}
	
	var sensorLocation : CLLocation? {
		return mapView.userLocation.location
	}
	
	
//    API calling
	var requestPending = MutableProperty(false)
	func returnBike(sender: AnyObject?) {
		let info = BikeReturnInfo(lat: mapLocation.latitude, lon: mapLocation.longitude, note: textView.text, sensorLat: sensorLocation?.coordinate.latitude, sensorLon: sensorLocation?.coordinate.longitude, sensorAcc: sensorLocation?.horizontalAccuracy)
		requestPending.value = true
		API.returnBike(id: bike.id, info: info).start(error: { error in
			self.requestPending.value = false
			self.handleError(error)
			}, completed: {
				self.requestPending.value = false
				self.navigationController?.popToRootViewControllerAnimated(true)
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
    
//    parsing Boundaries
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
    
//    MARK: MKMapViewDelegate
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
    
//    MARK: UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
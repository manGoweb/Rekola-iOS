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

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
		
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .rekolaGreenColor()
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        self.navigationItem.title = NSLocalizedString("RETURNBIKE_title", comment: "")
        
        self.descriptionLabel.text = NSLocalizedString("RETURNBIKE_description", comment: "")
        self.descriptionLabel.textAlignment = .Left

        
        textView.delegate = self
		textView.placeholder = NSLocalizedString("RETURN_PLACEHOLDER", comment: "")
        textView.textColor = .grayColor()
        textView.editable = true
        
        self.returnButton.setTitle(NSLocalizedString("RETURNBIKE_return" , comment: ""), forState: .Normal)
        
        self.mapView.delegate = self
        self.mapView.scrollEnabled = true
        self.mapView.zoomEnabled = true
        self.mapView.showsUserLocation = true
		
		navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: mapView)
		
		returnButton.addTarget(self, action: "returnBike:", forControlEvents: .TouchUpInside)
		returnButton.rac_enabled <~ requestPending.producer |> map { !$0 }
    }
	
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
	var mapLocation : CLLocationCoordinate2D {
		return mapView.centerCoordinate
	}
	
	var sensorLocation : CLLocation? {
		return mapView.userLocation.location
	}
	
	
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
    
//    MARK: UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
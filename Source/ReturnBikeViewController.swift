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

class ReturnBikeViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate {
    override func loadView() {
        let view = UIView()
        self.view = view
        
        let returnButton = Theme.pinkButton()
        view.addSubview(returnButton)
        returnButton.snp_makeConstraints { make in
            make.bottom.equalTo(view).offset(-L.verticalSpacing)
            make.height.equalTo(44)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.returnButton = returnButton
        
        let textView = UITextView()
        view.addSubview(textView)
        textView.editable = true
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 4
        textView.snp_makeConstraints { make in
            make.bottom.equalTo(returnButton.snp_top).offset(-L.horizontalSpacing)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.height.equalTo(72)
        }
        self.textView = textView
        
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .Left
        view.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints { make in
            make.bottom.equalTo(textView.snp_top).offset(-L.verticalSpacing)
            make.right.left.equalTo(view).offset(L.horizontalSpacing)
        }
        self.descriptionLabel = descriptionLabel
        
        let mapView = MKMapView()
        view.addSubview(mapView)
        mapView.snp_makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp_top).offset(-L.verticalSpacing)
            make.left.right.top.equalTo(view)
        }
        self.mapView = mapView
    }
    
    weak var mapView: MKMapView!
    weak var returnButton: UIButton!
    weak var textView: UITextView!
    weak var descriptionLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .rekolaGreenColor()
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        self.navigationItem.title = NSLocalizedString("RETURNBIKE_title", comment: "")
        
        self.view.backgroundColor = .whiteColor()
        
        self.descriptionLabel.text = NSLocalizedString("RETURNBIKE_description", comment: "")
        
        self.textView.delegate = self
        self.textView.text = "Např.: před vstupem do kavárny"
        self.textView.textColor = .grayColor()
        
        self.returnButton.setTitle(NSLocalizedString("RETURNBIKE_return" , comment: ""), forState: .Normal)
        
        self.mapView.delegate = self
        self.mapView.scrollEnabled = true
        self.mapView.zoomEnabled = true
        
        let button = MKUserTrackingBarButtonItem()
        self.navigationController?.navigationItem.rightBarButtonItem = button
    }
    
//    MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Např.: před vstupem do kavárny" {
            textView.text = ""
            textView.textColor = .blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "Např.: před vstupem do kavárny"
            textView.textColor = .grayColor()
        }
        textView.resignFirstResponder()
    }
}

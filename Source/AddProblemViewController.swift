//
//  AddProblemViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 10/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import SnapKit
import Foundation
import MapKit
import ReactiveCocoa

class AddProblemViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, ProblemsViewControllerProtocol, CLLocationManagerDelegate {
	
	let bike : Bike
	init(bike: Bike){
		self.bike = bike
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
        let view = UIView()
        self.view = view
        
        setupKeyboardLayoutGuide()
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { make in
            make.left.top.right.equalTo(view)
            make.bottom.equalTo(keyboardLayoutGuide)
        }
        self.scrollView = scrollView
        
        let container = UIView()
        scrollView.addSubview(container)
        container.snp_makeConstraints { make in
            make.width.equalTo(scrollView).offset(-(L.contentInsets.left + L.contentInsets.right))
            make.edges.equalTo(scrollView).inset(L.contentInsets)
//            make.height.equalTo(scrollView)
        }
        self.container = container
        
        let typeOfProblemLabel = UILabel()
        container.addSubview(typeOfProblemLabel)
        typeOfProblemLabel.textAlignment = .Left
        typeOfProblemLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 17)
        typeOfProblemLabel.snp_makeConstraints { make in
            make.top.equalTo(container).offset(86)
            make.left.right.equalTo(container).inset(L.contentInsets)
        }
        self.typeOfProblemLabel = typeOfProblemLabel
        
        let textField = UITextField()
        container.addSubview(textField)
        var spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .Always
        textField.leftView = spacerView
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.grayColor().CGColor//UIColor.rekolaPinkColor().CGColor
        textField.snp_makeConstraints { make in
            make.top.equalTo(typeOfProblemLabel.snp_bottom).offset(10)
            make.left.right.equalTo(container).inset(L.contentInsets)
            make.height.equalTo(45)
        }
        self.textField = textField
        
        let textFieldButton = UIButton()
        textFieldButton.setBackgroundImage(UIImage(imageIdentifier: .textFieldButton), forState: .Normal)
        textFieldButton.imageView!.contentMode = .ScaleAspectFit
        textFieldButton.addTarget(self, action: "textFieldShouldBeginEditing:", forControlEvents: .TouchUpInside)
        textField.addSubview(textFieldButton)
        textFieldButton.snp_makeConstraints { make in
            make.right.equalTo(textField.snp_right).offset(-L.horizontalSpacing)
            make.centerY.equalTo(textField.snp_centerY)
        }
        
        let descriptionLabel = UILabel()
        container.addSubview(descriptionLabel)
        descriptionLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 17)
        descriptionLabel.snp_makeConstraints{ make in
            make.top.equalTo(textField.snp_bottom).offset(30)
            make.left.right.equalTo(L.horizontalSpacing).inset(L.contentInsets)
        }
        self.descriptionLabel = descriptionLabel
        
        let textView = UITextView()
        container.addSubview(textView)
        textView.layer.borderColor = UIColor.grayColor().CGColor//UIColor.rekolaPinkColor().CGColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.editable = true
        textView.returnKeyType = .Done
        textView.snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(10)
            make.height.equalTo(99)
            make.left.right.equalTo(0).inset(L.contentInsets)
        }
        self.textView = textView
        
        let bikeToggleButton = UIButton()
        container.addSubview(bikeToggleButton)
        bikeToggleButton.snp_makeConstraints { make in
            make.top.equalTo(textView.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(container).offset(L.verticalSpacing)
        }
        self.bikeToggleButton = bikeToggleButton
        
        let unmovableBikeLabel = UILabel()
        container.addSubview(unmovableBikeLabel)
        unmovableBikeLabel.textColor = .grayColor()
        unmovableBikeLabel.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        unmovableBikeLabel.snp_makeConstraints { make in
            make.top.equalTo(textView.snp_bottom).offset(18)
            make.left.equalTo(bikeToggleButton.snp_right).offset(15)
        }
        self.unmovableBikeLabel = unmovableBikeLabel
        
        let reportProblemButton = Theme.pinkButton()
        container.addSubview(reportProblemButton)
        reportProblemButton.layer.cornerRadius = 5
        reportProblemButton.snp_makeConstraints{ make in
            make.top.equalTo(unmovableBikeLabel.snp_bottom).offset(20)
            make.left.right.equalTo(container).inset(L.contentInsets)
            make.height.equalTo(44)
            make.bottom.equalTo(container)
        }
        self.reportProblemButton = reportProblemButton
    }
    
    weak var scrollView: UIScrollView!
    weak var container: UIView!
    weak var typeOfProblemLabel: UILabel!
    weak var textField: UITextField!
    weak var descriptionLabel: UILabel!
    weak var textView: UITextView!
    weak var bikeToggleButton: UIButton!
    weak var unmovableBikeLabel: UILabel!
    weak var reportProblemButton: UIButton!
    var brokenBike: Bool = false
    let locationManager = CLLocationManager()
    var issueID = -1 //default wrong value
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .rekolaGreenColor()
        
        view.backgroundColor = .whiteColor()
        view.tintColor = .whiteColor()
        
        typeOfProblemLabel.text = NSLocalizedString("ADDPROBLEM_typeOfProblem", comment: "")
        
        textField.delegate = self
        textField.placeholder = NSLocalizedString("ADDPROBLEM_chooseProblem", comment: "")

        descriptionLabel.text = NSLocalizedString("ADDPROBLEM_description", comment: "")
        
        textView.delegate = self
        
        let bikeToggleImage = UIImage.toggleImage(.BikeToggle)
        bikeToggleButton.setImage(bikeToggleImage.on, forState: .Normal)
        bikeToggleButton.addTarget(self, action: "changeSelection:", forControlEvents: .TouchUpInside)
        
        unmovableBikeLabel.text = NSLocalizedString("ADDPROBLEM_unmovable", comment: "")
        
        reportProblemButton.setTitle(NSLocalizedString("ADDPROBLEM_reportProblem", comment: ""), forState: .Normal)
        reportProblemButton.addTarget(self, action: "reportProblem:", forControlEvents: .TouchUpInside)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    let problemPendingPost = MutableProperty(false)
    func reportProblem(sender: AnyObject?) {
        var everythingIsFilled = true
        
        if self.textField.text == "" || self.textView.text == "" {
            everythingIsFilled = false
        }
        
        if everythingIsFilled {
            let bikeID = self.issueID
            let title = self.textField.text
            let description = self.textView.text
            let disabling = self.brokenBike
            let location = self.locationManager.location.coordinate
        
            let reportLog = BikeReportProblem(type: bikeID, title: title, description: description, disabling: disabling, location: location)
            
            API.sendIssue(id: bike.id, issue: reportLog).start(error: { error in
                self.problemPendingPost.value = false
                self.handleError(error)
                }, completed: {
                    self.problemPendingPost.value = false
                    
//            TODO: Handle error
                    let alertView = UIAlertView(title: "Problem odeslan", message: "Problem byl odeslan", delegate: self, cancelButtonTitle: "OK")
                    alertView.show()
            })
            
        } else {
//            TODO: Handle error
            let alertView = UIAlertView(title: "Neni vse vyplneno", message: "Vypln vsechno", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
    func changeSelection(sender: UIButton) {
        let bikeToggleImage = UIImage.toggleImage(.BikeToggle)
        if sender.selected {
            sender.setImage(bikeToggleImage.0, forState: .Normal)
            sender.selected = false
            self.brokenBike = false
        } else {
            sender.setImage(bikeToggleImage.1, forState: .Selected)
            sender.selected = true
            self.brokenBike = true
        }
    }
	
//    MARK: ProblemsViewControllerProtocol
    func addProblemToTextField(controller: ProblemsViewController, problem: AddIssue) {
        self.textField.placeholder = "" //mozna tohle smazat
        self.textField.text = problem.title
        self.issueID = problem.id
        if textField.text == "" {
            textField.layer.borderColor = UIColor.grayColor().CGColor
        }
    }
    
//    MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.rekolaPinkColor().CGColor
        let vc = ProblemsViewController()
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text.isEmpty {
            textField.layer.borderColor = UIColor.grayColor().CGColor
        }
    }

//    MARK: UITextViewDelegate
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.layer.borderColor = UIColor.rekolaPinkColor().CGColor
        if self.view.bounds.size.height > 480 {
            dispatch_async(dispatch_get_main_queue()) {
                self.scrollView.scrollToBottom(true)
            }
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.layer.borderColor = UIColor.grayColor().CGColor
        }
    }
}

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

class AddProblemViewController: UIViewController, UITextFieldDelegate, ProblemsViewControllerProtocol {
	
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
        
        let typeOfProblemLabel = UILabel()
        view.addSubview(typeOfProblemLabel)
        typeOfProblemLabel.snp_makeConstraints { make in
            make.top.equalTo(view).offset(86)
            make.left.right.equalTo(view).offset(L.horizontalSpacing)
        }
        self.typeOfProblemLabel = typeOfProblemLabel
        
        let textField = UITextField()
        view.addSubview(textField)
        var spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .Always
        textField.leftView = spacerView
        textField.snp_makeConstraints { make in
            make.top.equalTo(typeOfProblemLabel.snp_bottom).offset(10)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
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
        view.addSubview(descriptionLabel)
        descriptionLabel.snp_makeConstraints{ make in
            make.top.equalTo(textField.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(L.horizontalSpacing)
        }
        self.descriptionLabel = descriptionLabel
        
        let textView = UITextView()
        view.addSubview(textView)
        textView.snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(L.verticalSpacing)
            make.height.equalTo(99)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.textView = textView
        
        let bikeToggleButton = UIButton()
        view.addSubview(bikeToggleButton)
        bikeToggleButton.snp_makeConstraints { make in
            make.top.equalTo(textView.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(view).offset(L.verticalSpacing)
        }
        self.bikeToggleButton = bikeToggleButton
        
        let unmovableBikeLabel = UILabel()
        view.addSubview(unmovableBikeLabel)
        unmovableBikeLabel.snp_makeConstraints { make in
            make.top.equalTo(textView.snp_bottom).offset(18)
            make.left.equalTo(bikeToggleButton.snp_right).offset(L.horizontalSpacing)
        }
        self.unmovableBikeLabel = unmovableBikeLabel
        
        let reportProblemButton = Theme.pinkButton()
        view.addSubview(reportProblemButton)
        reportProblemButton.snp_makeConstraints{ make in
            make.top.equalTo(unmovableBikeLabel.snp_bottom).offset(20)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.height.equalTo(44)
        }
        self.reportProblemButton = reportProblemButton
    }
    
    weak var typeOfProblemLabel: UILabel!
    weak var textField: UITextField!
    weak var descriptionLabel: UILabel!
    weak var textView: UITextView!
    weak var bikeToggleButton: UIButton!
    weak var unmovableBikeLabel: UILabel!
    weak var reportProblemButton: UIButton!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = .rekolaGreenColor()
        
        self.view.backgroundColor = .whiteColor()
        self.view.tintColor = .whiteColor()
        
        self.typeOfProblemLabel.text = NSLocalizedString("ADDPROBLEM_typeOfProblem", comment: "")
        self.typeOfProblemLabel.textAlignment = .Left
        
        self.textField.delegate = self
        self.textField.placeholder = NSLocalizedString("ADDPROBLEM_chooseProblem", comment: "")
        self.textField.layer.borderWidth = 2
        self.textField.layer.cornerRadius = 5
        self.textField.layer.borderColor = UIColor.rekolaPinkColor().CGColor
        
        self.descriptionLabel.text = NSLocalizedString("ADDPROBLEM_description", comment: "")
        
        self.textView.layer.borderColor = UIColor.rekolaPinkColor().CGColor
        self.textView.layer.borderWidth = 2
        self.textView.layer.cornerRadius = 5
        self.textView.editable = true
        
        let bikeToggleImage = UIImage.toggleImage(.BikeToggle)
        self.bikeToggleButton.setImage(bikeToggleImage.on, forState: .Normal)
        self.bikeToggleButton.addTarget(self, action: "changeSelection:", forControlEvents: .TouchUpInside)
        
        self.unmovableBikeLabel.text = NSLocalizedString("ADDPROBLEM_unmovable", comment: "")
        self.unmovableBikeLabel.textColor = .grayColor()
        
        self.reportProblemButton.setTitle(NSLocalizedString("ADDPROBLEM_reportProblem", comment: ""), forState: .Normal)
        self.reportProblemButton.layer.cornerRadius = 5
    }
    
    func changeSelection(sender: UIButton) {
        let bikeToggleImage = UIImage.toggleImage(.BikeToggle)
        if sender.selected {
            sender.setImage(bikeToggleImage.0, forState: .Normal)
            sender.selected = false
        } else {
            sender.setImage(bikeToggleImage.1, forState: .Selected)
            sender.selected = true
        }
    }
	
	//TODO: zjistit co vraci api a doplnit logiku (porad se se mnou), urcite neifovat podle stringu
//    MARK: ProblemsViewControllerProtocol
    func addProblemToTextField(controller: ProblemsViewController, problem: String) {
        self.textField.placeholder = ""
        if problem != "Jiny problem" { //will be change with API
            self.textField.text = problem
        } else {
            self.textField.text = "Jiny problem"
            self.textField.becomeFirstResponder()
        }
    }
    
//    MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if self.textField.text == "Jiny problem" { //will be change with API
            self.textField.text = ""
            return true
        } else {
            let vc = ProblemsViewController()
            vc.delegate = self
            presentViewController(vc, animated: true, completion: nil)
            return false
        }

    }

}

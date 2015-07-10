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

class AddProblemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    override func loadView() {
        let view = UIView()
        self.view = view
        
        let typeOfProblemLabel = UILabel()
        typeOfProblemLabel.textAlignment = .Left
        view.addSubview(typeOfProblemLabel)
        typeOfProblemLabel.snp_makeConstraints { make in
            make.top.equalTo(view).offset(66)
            make.left.right.equalTo(view).offset(L.horizontalSpacing)
        }
        self.typeOfProblemLabel = typeOfProblemLabel
        
        let textField = UITextField()
        view.addSubview(textField)
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.rekolaPinkColor().CGColor
        textField.snp_makeConstraints { make in
            make.top.equalTo(typeOfProblemLabel.snp_bottom).offset(10)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.height.equalTo(45)
        }
        self.textField = textField
        
        let viewForPicking = UIView()
        view.addSubview(viewForPicking)
        viewForPicking.alpha = 0.0
        viewForPicking.snp_makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }
        self.viewForPicking = viewForPicking
        
        let pickerView = UIPickerView()
        view.addSubview(pickerView)
        pickerView.snp_makeConstraints { make in
            make.top.equalTo(textField.snp_bottom)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.problemsPickerView = pickerView
        

    }
    
    weak var typeOfProblemLabel: UILabel!
    weak var problemsPickerView: UIPickerView!
    weak var textField: UITextField!
    weak var viewForPicking: UIView!
    let problems = ["Kolo tu neni", "Kod zamku nefunguje", "Pichla duse", "Problem s retezem", "Neco je s ramem", "Neco chybi", "Tohle maji byt brzdy?", "Bal bych se na tom jet", "Jiny problem"]

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = .rekolaGreenColor()
        
        self.view.backgroundColor = .whiteColor()
        self.view.tintColor = .whiteColor()
        
        self.typeOfProblemLabel.text = NSLocalizedString("ADDPROBLEM_typeOfProblem", comment: "")
        
        self.problemsPickerView.delegate = self
        self.textField.delegate = self
        self.textField.placeholder = "  " + NSLocalizedString("ADDPROBLEM_chooseProblem", comment: "")
        
        self.problemsPickerView.hidden = true
        self.viewForPicking.backgroundColor = .rekolaPinkColor()
        
    }
    
//    MARK: UIPickerViewDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return problems.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return problems[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = problems[row]
        problemsPickerView.hidden = true
    }
    
//    MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.navigationController?.navigationBar.hidden = true
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
        self.viewForPicking.alpha = 1.0}, completion: nil)
        textField.text = ""
        return false
    }

}

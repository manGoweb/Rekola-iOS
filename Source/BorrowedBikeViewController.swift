//
//  BorrowBikeViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 08/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

class BorrowedBikeViewController: UIViewController {
	let bike : Bike
	init(bike: Bike) {
		self.bike = bike
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	override func loadView() {
        let view = UIView()
        self.view = view
        
        let iv = UIImageView()
		iv.contentMode = .ScaleAspectFit
        view.addSubview(iv)
        iv.snp_makeConstraints { make in
            make.top.equalTo(view).offset(23)
            make.right.left.equalTo(view)
            make.height.equalTo(self.view).multipliedBy(0.2)
        }
        self.bikeImageView = iv

        let nameLabel = UILabel()
        view.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(iv.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(view)
        }
        self.bikeNameLabel = nameLabel
        
        let borrowLabel = UILabel()
        view.addSubview(borrowLabel)
        borrowLabel.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(view)
        }
        self.bikeBorrowLabel = borrowLabel
        
        let detailButton = TintingButton(titleAndImageTintedWith: .rekolaGreenColor(), activeTintColor: .rekolaGreenColor())
        view.addSubview(detailButton)
        detailButton.snp_makeConstraints { make in
            make.top.equalTo(borrowLabel.snp_bottom).offset(L.verticalSpacing)
            make.width.equalTo(119)
            make.height.equalTo(45)
            make.centerX.equalTo(view.snp_centerX)
        }
        self.bikeDetailButton = detailButton
        
        let rectangle = UIView()
        rectangle.layer.borderWidth = 2
        rectangle.layer.borderColor = UIColor.rekolaGrayBorderColor().CGColor
        rectangle.layer.cornerRadius = 7
        view.addSubview(rectangle)
        rectangle.snp_makeConstraints { make in
            make.top.equalTo(detailButton.snp_bottom).multipliedBy(1.1)
            make.height.equalTo(101).multipliedBy(0.1)
            make.left.right.equalTo(view).insets(L.contentInsets)
            make.centerX.equalTo(view.snp_centerX)
        }
        
        let lockCodeLabel = InsetLabel()
        lockCodeLabel.textColor = .rekolaGrayBorderColor()
        lockCodeLabel.text = NSLocalizedString("BORROWBIKE_code", comment: "")
        lockCodeLabel.inset.left = 5
        lockCodeLabel.inset.right = 5
        lockCodeLabel.textAlignment = .Center
        lockCodeLabel.backgroundColor = .whiteColor()
        view.addSubview(lockCodeLabel)
        lockCodeLabel.snp_makeConstraints { make in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(rectangle.snp_top)
        }
        
        let codeLabel = UILabel()
        view.addSubview(codeLabel)
        codeLabel.snp_makeConstraints { make in
            make.top.equalTo(rectangle.snp_top).offset(5)
            make.left.equalTo(rectangle.snp_left)
            make.right.equalTo(rectangle.snp_right)
            make.bottom.equalTo(rectangle.snp_bottom)
        }
        self.bikeCodeLabel = codeLabel
        
        let returnButton = Theme.pinkButton()
        view.addSubview(returnButton)
        returnButton.snp_makeConstraints { make in
            make.bottom.equalTo(view).offset(-L.verticalSpacing)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.height.equalTo(45)
        }
        self.bikeReturnButton = returnButton
    }
    
    weak var bikeImageView: UIImageView!
    weak var bikeNameLabel: UILabel!
    weak var bikeBorrowLabel: UILabel!
    weak var bikeDetailButton: TintingButton!
    weak var bikeCodeImage: UIImageView!
    weak var bikeCodeLabel: UILabel!
    weak var bikeReturnButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .whiteColor()
        self.bikeImageView.contentMode = .ScaleAspectFit

        self.bikeNameLabel.text = bike.name
        self.bikeNameLabel.font = UIFont.systemFontOfSize(24)
        self.bikeNameLabel.textAlignment = .Center

		//TODO:use bike.returnedAt with a date formatters for date and time
//        self.bikeBorrowLabel = formatLabel(self.bikeBorrowLabel,date: date, time: time)
        self.bikeBorrowLabel.font = UIFont.systemFontOfSize(14)
        self.bikeBorrowLabel.textAlignment = .Center
        
        self.bikeDetailButton.setTitle(NSLocalizedString("BORROWBIKE_detail", comment: ""), forState: .Normal)
        self.bikeDetailButton.layer.borderColor = UIColor.rekolaGreenColor().CGColor
        self.bikeDetailButton.layer.cornerRadius = 4
        self.bikeDetailButton.layer.borderWidth = 2
        
        self.bikeDetailButton.addTarget(self, action: "bikeDetail:", forControlEvents: .TouchUpInside)
        
        self.bikeCodeLabel.text = bike.lockCode
        self.bikeCodeLabel.font = UIFont.boldSystemFontOfSize(70)
        self.bikeCodeLabel.textAlignment = .Center
        
        self.bikeReturnButton.setTitle(NSLocalizedString("BORROWBIKE_return", comment: ""), forState: .Normal)
        self.bikeReturnButton.addTarget(self, action: "returnBike:", forControlEvents: .TouchUpInside)
		
		bikeImageView.sd_setImageWithURL(bike.imageURL)
    }
    
    func formatLabel(label: UILabel, date: String, time: String) -> UILabel! {
        let text = NSLocalizedString("BORROWBIKE_lent", comment: "") + date + "/" + time
        
        let atribute = NSMutableAttributedString(string: text)
        atribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.rekolaPinkColor(), range: NSRange(location: 8, length: 6))
        atribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.rekolaPinkColor(), range: NSRange(location: 15, length: 5))
        
        label.attributedText = atribute
        return label
    }
    
	func returnBike(sender: AnyObject?) {
		let vc = ReturnBikeViewController(bike: bike)
        showViewController(vc, sender: sender)
    }
    
	func bikeDetail(sender: AnyObject?) {
		let vc = BikeDetailViewController(bike: bike)
        showViewController(vc, sender: sender)
    }
}

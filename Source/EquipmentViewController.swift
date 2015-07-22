//
//  ViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 15/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class EquipmentViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        self.view = view
        
        let container = UIView()
        view.addSubview(container)
        container.layer.cornerRadius = 5
//        container.layer.borderColor = UIColor.blackColor().CGColor
        container.snp_makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }
        self.container = container
        
        let infoEquipmentLabel = UILabel()
        container.addSubview(infoEquipmentLabel)
        infoEquipmentLabel.snp_makeConstraints { make in
            make.top.equalTo(container).offset(L.verticalSpacing)
            make.left.equalTo(container).offset(L.horizontalSpacing)
        }
        self.infoEquipmentLabel = infoEquipmentLabel
        
        let exitButton = UIButton()
        container.addSubview(exitButton)
        exitButton.snp_makeConstraints { make in
            make.top.equalTo(container).offset(L.verticalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
        }
        self.exitButton = exitButton
        
        let infoMudguardIV = UIImageView(image: UIImage(imageIdentifier: .mudguard))
        container.addSubview(infoMudguardIV)
        infoMudguardIV.contentMode = .ScaleAspectFit
        infoMudguardIV.setContentHuggingPriority(1000, forAxis: .Horizontal)
        infoMudguardIV.snp_makeConstraints { make in
            make.top.equalTo(infoEquipmentLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
        }
        
        let infoBasketIV = UIImageView(image: UIImage(imageIdentifier: .basket))
        container.addSubview(infoBasketIV)
        infoBasketIV.contentMode = .ScaleAspectFit
        infoBasketIV.setContentHuggingPriority(1000, forAxis: .Horizontal)
        infoBasketIV.snp_makeConstraints { make in
            make.top.equalTo(infoMudguardIV.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
        }
        
        let infoBuzzerIV = UIImageView(image: UIImage(imageIdentifier: .buzzer))
        container.addSubview(infoBuzzerIV)
        infoBuzzerIV.contentMode = .ScaleAspectFit
        infoBuzzerIV.setContentHuggingPriority(1000, forAxis: .Horizontal)
        infoBuzzerIV.snp_makeConstraints { make in
            make.top.equalTo(infoBasketIV.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
        }
        
        let infoBacklightIV = UIImageView(image: UIImage(imageIdentifier: .backlight))
        container.addSubview(infoBacklightIV)
        infoBacklightIV.contentMode = .ScaleAspectFit
        infoBacklightIV.setContentHuggingPriority(1000, forAxis: .Horizontal)
        infoBacklightIV.snp_makeConstraints { make in
            make.top.equalTo(infoBuzzerIV.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
        }
        
        let infoFrontlightIV = UIImageView(image: UIImage(imageIdentifier: .frontlight))
        container.addSubview(infoFrontlightIV)
        infoFrontlightIV.contentMode = .ScaleAspectFit
        infoFrontlightIV.setContentHuggingPriority(1000, forAxis: .Horizontal)
        infoFrontlightIV.snp_makeConstraints { make in
            make.top.equalTo(infoBacklightIV.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
        }
        
        let infoTrunkIV = UIImageView(image: UIImage(imageIdentifier: .trunk))
        container.addSubview(infoTrunkIV)
        infoTrunkIV.contentMode = .ScaleAspectFit
        infoTrunkIV.setContentHuggingPriority(1000, forAxis: .Horizontal)
        infoTrunkIV.snp_makeConstraints { make in
            make.top.equalTo(infoFrontlightIV.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
        }
        
        //        need to repair it (strings and position)
        let infoMudguardLabel = UILabel()
        container.addSubview(infoMudguardLabel)
        infoMudguardLabel.textAlignment = .Left
        infoMudguardLabel.text = "Blatniky"
        infoMudguardLabel.snp_makeConstraints { make in
            make.top.equalTo(infoEquipmentLabel.snp_bottom).offset(25)
            make.left.equalTo(infoMudguardIV.snp_right).offset(20)
            make.right.equalTo(-L.horizontalSpacing)
        }
        
        let infoBasketLabel = UILabel()
        container.addSubview(infoBasketLabel)
        infoBasketLabel.textAlignment = .Left
        infoBasketLabel.text = "Kosik"
        infoBasketLabel.snp_makeConstraints { make in
            make.top.equalTo(infoMudguardLabel.snp_bottom).offset(25)
            make.left.equalTo(infoBasketIV.snp_right).offset(20)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
        }
        
        let infoBuzzerLabel = UILabel()
        container.addSubview(infoBuzzerLabel)
        infoBuzzerLabel.textAlignment = .Left
        infoBuzzerLabel.text = "Zvonek"
        infoBuzzerLabel.snp_makeConstraints { make in
            make.top.equalTo(infoBasketLabel.snp_bottom).offset(25)
            make.left.equalTo(infoBuzzerIV.snp_right).offset(20)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
        }
        
        let infoBacklightLabel = UILabel()
        container.addSubview(infoBacklightLabel)
        infoBacklightLabel.textAlignment = .Left
        infoBacklightLabel.text = "Zadni svetla"
        infoBacklightLabel.snp_makeConstraints { make in
            make.top.equalTo(infoBuzzerLabel.snp_bottom).offset(25)
            make.left.equalTo(infoBacklightIV.snp_right).offset(20)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
        }
        
        let infoFrontlightLabel = UILabel()
        container.addSubview(infoFrontlightLabel)
        infoFrontlightLabel.textAlignment = .Left
        infoFrontlightLabel.text = "Predni svetla"
        infoFrontlightLabel.snp_makeConstraints { make in
            make.top.equalTo(infoBacklightLabel.snp_bottom).offset(25)
            make.left.equalTo(infoFrontlightIV.snp_right).offset(20)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
        }
        
        let infoTrunkLabel = UILabel()
        container.addSubview(infoTrunkLabel)
        infoTrunkLabel.textAlignment = .Left
        infoTrunkLabel.text = "Nosic"
        infoTrunkLabel.snp_makeConstraints { make in
            make.top.equalTo(infoFrontlightLabel.snp_bottom).offset(25)
            make.left.equalTo(infoTrunkIV.snp_right).offset(20)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.bottom.equalTo(container).offset(-L.verticalSpacing)
        }
    }
    
    weak var container: UIView!
    weak var infoEquipmentLabel: UILabel!
    weak var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.backgroundColor = .whiteColor()
        
        infoEquipmentLabel.text = NSLocalizedString("BIKEDETAIL_equipment", comment: "")
        
        exitButton.setImage(UIImage(imageIdentifier: .cancelButton), forState: .Normal)
        exitButton.imageView?.contentMode = .ScaleAspectFit
        exitButton.addTarget(self, action: "cancelView", forControlEvents: .TouchUpInside)
    }
    
    func cancelView() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

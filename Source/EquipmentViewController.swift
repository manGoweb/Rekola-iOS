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
        
        let infoEquipmentLabel = UILabel()
        view.addSubview(infoEquipmentLabel)
        infoEquipmentLabel.snp_makeConstraints { make in
            make.top.equalTo(view).offset(L.verticalSpacing)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.infoEquipmentLabel = infoEquipmentLabel
        
        let infoMudguardIV = UIImageView(image: UIImage(imageIdentifier: .mudguard))
        view.addSubview(infoMudguardIV)
        infoMudguardIV.contentMode = .ScaleAspectFit
        infoMudguardIV.setContentHuggingPriority(1000, forAxis: .Horizontal)
        infoMudguardIV.snp_makeConstraints { make in
            make.top.equalTo(infoEquipmentLabel.snp_bottom).offset(20)
            make.left.equalTo(L.horizontalSpacing)
        }
        
        let infoBasketIV = UIImageView(image: UIImage(imageIdentifier: .basket))
        view.addSubview(infoBasketIV)
        infoBasketIV.contentMode = .ScaleAspectFit
        infoBasketIV.snp_makeConstraints { make in
            make.top.equalTo(infoMudguardIV.snp_bottom).offset(20)
            make.left.equalTo(view).offset(L.horizontalSpacing)
        }
        
        let infoBuzzerIV = UIImageView(image: UIImage(imageIdentifier: .buzzer))
        view.addSubview(infoBuzzerIV)
        infoBuzzerIV.contentMode = .ScaleAspectFit
        infoBuzzerIV.snp_makeConstraints { make in
            make.top.equalTo(infoBasketIV.snp_bottom).offset(20)
            make.left.equalTo(view).offset(L.horizontalSpacing)
        }
        
        let infoBacklightIV = UIImageView(image: UIImage(imageIdentifier: .backlight))
        view.addSubview(infoBacklightIV)
        infoBacklightIV.contentMode = .ScaleAspectFit
        infoBacklightIV.snp_makeConstraints { make in
            make.top.equalTo(infoBuzzerIV.snp_bottom).offset(20)
            make.left.equalTo(view).offset(L.horizontalSpacing)
        }
        
        let infoFrontlightIV = UIImageView(image: UIImage(imageIdentifier: .frontlight))
        view.addSubview(infoFrontlightIV)
        infoFrontlightIV.contentMode = .ScaleAspectFit
        infoFrontlightIV.snp_makeConstraints { make in
            make.top.equalTo(infoBacklightIV.snp_bottom).offset(20)
            make.left.equalTo(view).offset(L.horizontalSpacing)
        }
        
        let infoTrunkIV = UIImageView(image: UIImage(imageIdentifier: .trunk))
        view.addSubview(infoTrunkIV)
        infoTrunkIV.contentMode = .ScaleAspectFit
        infoTrunkIV.snp_makeConstraints { make in
            make.top.equalTo(infoFrontlightIV.snp_bottom).offset(20)
            make.left.equalTo(view).offset(L.horizontalSpacing)
        }
        
        //        need to repair it (strings and position)
        let infoMudguardLabel = UILabel()
        view.addSubview(infoMudguardLabel)
        infoMudguardLabel.textAlignment = .Left
        infoMudguardLabel.text = "Blatniky"
        infoMudguardLabel.snp_makeConstraints { make in
            make.top.equalTo(infoEquipmentLabel.snp_bottom).offset(25)
            make.left.equalTo(infoMudguardIV.snp_right).offset(20)
            make.right.equalTo(-L.horizontalSpacing)
        }
        
        let infoBasketLabel = UILabel()
        view.addSubview(infoBasketLabel)
        infoBasketLabel.textAlignment = .Left
        infoBasketLabel.text = "Kosik"
        infoBasketLabel.snp_makeConstraints { make in
            make.top.equalTo(infoMudguardLabel.snp_bottom).offset(25)
            make.left.equalTo(infoBasketIV.snp_right).offset(20)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        
        let infoBuzzerLabel = UILabel()
        view.addSubview(infoBuzzerLabel)
        infoBuzzerLabel.textAlignment = .Left
        infoBuzzerLabel.text = "Zvonek"
        infoBuzzerLabel.snp_makeConstraints { make in
            make.top.equalTo(infoBasketLabel.snp_bottom).offset(25)
            make.left.equalTo(infoBuzzerIV.snp_right).offset(20)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        
        let infoBacklightLabel = UILabel()
        view.addSubview(infoBacklightLabel)
        infoBacklightLabel.textAlignment = .Left
        infoBacklightLabel.text = "Zadni svetla"
        infoBacklightLabel.snp_makeConstraints { make in
            make.top.equalTo(infoBuzzerLabel.snp_bottom).offset(25)
            make.left.equalTo(infoBacklightIV.snp_right).offset(20)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        
        let infoFrontlightLabel = UILabel()
        view.addSubview(infoFrontlightLabel)
        infoFrontlightLabel.textAlignment = .Left
        infoFrontlightLabel.text = "Predni svetla"
        infoFrontlightLabel.snp_makeConstraints { make in
            make.top.equalTo(infoBacklightLabel.snp_bottom).offset(25)
            make.left.equalTo(infoFrontlightIV.snp_right).offset(20)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        
        let infoTrunkLabel = UILabel()
        view.addSubview(infoTrunkLabel)
        infoTrunkLabel.textAlignment = .Left
        infoTrunkLabel.text = "Nosic"
        infoTrunkLabel.snp_makeConstraints { make in
            make.top.equalTo(infoFrontlightLabel.snp_bottom).offset(25)
            make.left.equalTo(infoTrunkIV.snp_right).offset(20)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.bottom.equalTo(view).offset(-L.verticalSpacing)
        }
    }
    
    weak var infoEquipmentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoEquipmentLabel.text = NSLocalizedString("BIKEDETAIL_equipment", comment: "")
    }
}

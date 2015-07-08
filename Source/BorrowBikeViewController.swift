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

class BorrowBikeViewController: UIViewController {
    override func loadView() {
        let view = UIView()
        self.view = view
        
        let iv = UIImageView(image: UIImage(imageIdentifier: .borrowBike))
        view.addSubview(iv)
        iv.snp_makeConstraints { make in
            make.top.equalTo(view).offset(50)
            make.right.left.equalTo(view)
        }
        self.bikeImageView = iv
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFontOfSize(24)
        nameLabel.textAlignment = .Center
        view.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(iv.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(view)
        }
        self.bikeNameLabel = nameLabel
        
        let borrowLabel = UILabel()
        borrowLabel.font = UIFont.systemFontOfSize(14)
        borrowLabel.textAlignment = .Center
        view.addSubview(borrowLabel)
        borrowLabel.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(view)
        }
        self.bikeBorrowLabel = borrowLabel
        
    }
    
    weak var bikeImageView: UIImageView!
    weak var bikeNameLabel: UILabel!
    weak var bikeBorrowLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .whiteColor()
        self.bikeImageView.contentMode = .ScaleAspectFit
        
        self.bikeNameLabel.text = "Kníže Pupík Ignor"
        
        self.bikeBorrowLabel = formatLabel(self.bikeBorrowLabel,date: "25.08", time: "14:53")
    }
    
    func formatLabel(label: UILabel, date: String, time: String) -> UILabel! {
        let text = "Půjčeno " + date + "/" + time
        
        let atribute = NSMutableAttributedString(string: text)
        atribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 8, length: 5))
        atribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 14, length: 5))
        
        label.attributedText = atribute
        return label
    }
}

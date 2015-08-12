//
//  EquipmentCollectionViewCell.swift
//  Rekola
//
//  Created by Daniel Brezina on 12/08/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class EquipmentCollectionViewCell: UICollectionViewCell {
    weak var equipmentImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let newImageView = UIImageView()
        contentView.addSubview(newImageView)
        newImageView.snp_makeConstraints { make in
            make.top.equalTo(contentView)
            make.height.equalTo(31)
            make.width.equalTo(31)
        }
        equipmentImage = newImageView
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

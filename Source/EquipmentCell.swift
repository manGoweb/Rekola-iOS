//
//  EquipmentCell.swift
//  Rekola
//
//  Created by Daniel Brezina on 19/08/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class EquipmentCell: UITableViewCell {
    
    weak var equipmentImageView: UIImageView!
    weak var descriptionLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.contentMode = .ScaleAspectFit
        imageView.setContentHuggingPriority(1000, forAxis: .Horizontal)
        imageView.snp_makeConstraints { make in
            make.top.bottom.equalTo(self.contentView).inset(L.contentInsets)
            make.left.equalTo(self.contentView).offset(L.horizontalSpacing)
            make.width.equalTo(30)
        }
        self.equipmentImageView = imageView
        
        let descriptionLabel = UILabel()
        contentView.addSubview(descriptionLabel)
        descriptionLabel.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        descriptionLabel.textColor = .rekolaBlackColor()
        descriptionLabel.snp_makeConstraints { make in
            make.top.right.bottom.equalTo(self.contentView).inset(L.contentInsets)
            make.left.equalTo(equipmentImageView.snp_right).offset(20)
        }
        self.descriptionLabel = descriptionLabel
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}

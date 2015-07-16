//
//  ProblemCell.swift
//  Rekola
//
//  Created by Daniel Brezina on 13/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class ProblemCell: UITableViewCell {
    weak var nameLabel: UILabel!
    weak var descriptionLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel = UILabel()
        nameLabel.textColor = .blackColor()
        nameLabel.textAlignment = .Left
        nameLabel.font = UIFont.boldSystemFontOfSize(16)
        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(self.contentView).offset(L.verticalSpacing)
            make.left.equalTo(self.contentView).offset(L.horizontalSpacing)
            make.right.equalTo(self.contentView).offset(-L.horizontalSpacing)
        }
        self.contentView.addSubview(nameLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.textColor = .grayColor()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .Left
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(self.contentView).offset(L.horizontalSpacing)
            make.right.equalTo(self.contentView).offset(-L.horizontalSpacing)
        }
        self.contentView.addSubview(descriptionLabel)

    }
}
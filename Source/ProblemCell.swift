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
    weak var line: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let newNameLabel = UILabel()
        newNameLabel.textColor = .rekolaBlackColor()
        newNameLabel.textAlignment = .Left
        newNameLabel.numberOfLines = 0
        newNameLabel.font = UIFont(name: Theme.SFFont.Bold.rawValue, size: 15)
        contentView.addSubview(newNameLabel)
        newNameLabel.snp_makeConstraints { make in
            make.top.right.equalTo(self.contentView).inset(L.contentInsets)
            make.left.equalTo(contentView).offset(14)
        }
        self.nameLabel = newNameLabel
        
        let newDescriptionLabel = UILabel()
        newDescriptionLabel.textColor = .grayColor()
        newDescriptionLabel.numberOfLines = 0
        newDescriptionLabel.textAlignment = .Left
        newDescriptionLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 14)
        contentView.addSubview(newDescriptionLabel)
        newDescriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(newNameLabel.snp_bottom).offset(5)
            make.right.equalTo(contentView).inset(L.contentInsets)
            make.left.equalTo(contentView).offset(14)
        }
        
        self.descriptionLabel = newDescriptionLabel
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
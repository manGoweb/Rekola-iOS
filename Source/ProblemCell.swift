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
    weak var typeLabel: UILabel!
    weak var nameLabel: UILabel!
    weak var descriptionLabel: UILabel!
    weak var line: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        let newTypeLabel = UILabel()
        newTypeLabel.textColor = .rekolaGreenColor()
        newTypeLabel.textAlignment = .Left
        newTypeLabel.font = UIFont.boldSystemFontOfSize(16)
        contentView.addSubview(newTypeLabel)
        newTypeLabel.snp_makeConstraints{ make in
            make.left.top.right.equalTo(self.contentView).inset(L.contentInsets)
        }
        self.typeLabel = newTypeLabel
        
        let newNameLabel = UILabel()
        newNameLabel.textColor = .blackColor()
        newNameLabel.textAlignment = .Left
        newNameLabel.font = UIFont.boldSystemFontOfSize(16)
        contentView.addSubview(newNameLabel)
        newNameLabel.snp_makeConstraints { make in
            make.top.equalTo(newTypeLabel.snp_bottom).offset(10)
            make.left.right.equalTo(self.contentView).inset(L.contentInsets)
        }
        
        self.nameLabel = newNameLabel
        
        let newDescriptionLabel = UILabel()
        newDescriptionLabel.textColor = .grayColor()
        newDescriptionLabel.numberOfLines = 0
        newDescriptionLabel.textAlignment = .Left
        contentView.addSubview(newDescriptionLabel)
        newDescriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(newNameLabel.snp_bottom).offset(10)
            make.left.right.equalTo(contentView).inset(L.contentInsets)
        }
        
        self.descriptionLabel = newDescriptionLabel
        
        let newLine = UIView()
        newLine.backgroundColor = .rekolaGrayLineColor()
        contentView.addSubview(newLine)
        newLine.snp_makeConstraints { make in
            make.top.equalTo(newDescriptionLabel.snp_bottom).offset(5)
            make.left.right.equalTo(contentView).inset(L.contentInsets)
            make.height.equalTo(1)
        }
        self.line = newLine
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
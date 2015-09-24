//
//  NameProblemCell.swift
//  Rekola
//
//  Created by Daniel Brezina on 24/09/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class NameProblemCell: UITableViewCell {

    weak var nameLabel: UILabel!
    weak var line: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let newNameLabel = UILabel()
        newNameLabel.textColor = .whiteColor()
        newNameLabel.textAlignment = .Left
        newNameLabel.numberOfLines = 0
        newNameLabel.font = UIFont(name: Theme.SFFont.Bold.rawValue, size: 15)
        contentView.addSubview(newNameLabel)
        newNameLabel.snp_makeConstraints { make in
            make.top.right.equalTo(self.contentView).inset(L.contentInsets)
            make.left.equalTo(contentView).offset(14)
        }
        self.nameLabel = newNameLabel
        
        let line = UIView()
        contentView.addSubview(line)
        line.backgroundColor = .whiteColor()
        line.alpha = 0.3
        line.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp_bottom).offset(7)
            make.left.right.equalTo(self.contentView).inset(L.contentInsets)
            make.height.equalTo(1)
        }
        self.line = line
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

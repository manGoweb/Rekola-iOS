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
    weak var problemLabel: UILabel!
    weak var bottomLine: UIView!
    
    init() {
        super.init(style: .Default, reuseIdentifier: "cell")
        
        self.problemLabel.textColor = .whiteColor()
        self.problemLabel.textAlignment = .Left
        self.problemLabel.font = UIFont.systemFontOfSize(15)
        
        self.bottomLine.backgroundColor = .whiteColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let problemLbl = UILabel()
        self.contentView.addSubview(problemLbl)
        self.problemLabel = problemLbl
        
        let line = UILabel()
        self.contentView.addSubview(line)
        line.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(problemLbl.snp_bottom).offset(10)
            make.left.equalTo(self.contentView).offset(30)
            make.right.equalTo(self.contentView).offset(-30)
        }
        self.bottomLine = line
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
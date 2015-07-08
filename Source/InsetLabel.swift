//
//  InsetLabel.swift
//  Rekola
//
//  Created by Daniel Brezina on 08/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {
    var inset: UIEdgeInsets = UIEdgeInsetsZero
    
    override func intrinsicContentSize() -> CGSize {
        var superSize = super.intrinsicContentSize()
        superSize.width += inset.left + inset.right
        superSize.height += inset.top + inset.bottom
        return superSize
        }
}
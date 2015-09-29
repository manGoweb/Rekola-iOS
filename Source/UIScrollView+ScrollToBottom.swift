//
//  UIScrollView+ScrollToBottom.swift
//  Rekola
//
//  Created by Petr Šíma on Jul/30/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation

extension UIScrollView {
	func scrollToBottom(animated: Bool) {
		if(contentSize.height > bounds.size.height){
			setContentOffset(CGPoint(x: contentOffset.x, y: contentSize.height - bounds.size.height), animated: animated)
		}
	}
}
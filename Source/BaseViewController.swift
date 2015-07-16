//
//  BaseViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 16/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIViewControllerTransitioningDelegate {

    var modalAnimation: ModalAnimation = ModalAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    
    func presentPopupViewController(viewControllerToPresent: UIViewController, completion: (() -> Void)?) {
        viewControllerToPresent.transitioningDelegate = self
        viewControllerToPresent.modalPresentationStyle = .Custom
        
        self.presentViewController(viewControllerToPresent, animated: true, completion: completion)
    }
    
//    MARK: Transitioning Delegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.modalAnimation.type = AnimationTypePresent
        
        return self.modalAnimation
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.modalAnimation.type = AnimationTypeDismiss
        
        return self.modalAnimation
    }
}

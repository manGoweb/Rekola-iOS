//
//  TabBarController.swift
//  Rekola
//
//  Created by Dominik Vesely on 19/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation


protocol ACKTabBarItem {
    
    func select()
    func deselect()
    
    var view : UIView {get}
    var viewController: UIViewController {get set}
    var tabBar : ACKTabBar? {get set}
    
    func didSelect()
    func didDeselect()
    
    
}

protocol ACKTabBar : class {
    
    func selectTab(index : Int)
    var items : [ACKTabBarItem] {get set}
    var selectedIndex : Int { get set}
    var selectedController : UIViewController! { get set}
    
}


class TabItem : UIButton, ACKTabBarItem {
    
    var selectedBackgroundColor : UIColor = .rekolaGreenColor()
    var deselectedBackgroundColor : UIColor = .rekolaGreenColor()
    
    
    
    required init(controller: UIViewController, selectedImage : UIImage, deselectedImage : UIImage ) {
        self.viewController = controller
        super.init(frame: CGRectZero)
        self.setBackgroundImage(UIImage(color:selectedBackgroundColor), forState: UIControlState.Selected)
        self.setBackgroundImage(UIImage(color:deselectedBackgroundColor), forState: UIControlState.Normal)
        self.setImage(selectedImage, forState: UIControlState.Selected)
        self.setImage(deselectedImage, forState: UIControlState.Normal)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: TabBar
    
    var viewController : UIViewController
    weak var tabBar : ACKTabBar?
    var view : UIView  {
        get {
            return self
        }
    }
    
    
    func select() {
        
    }
    
    func deselect() {
        
    }
    
    func didSelect() {
        
    }
    
    func didDeselect() {
        
    }
    
    
}


class ACKTabBarController :UIViewController, ACKTabBar  {
    
    
    weak var containerView: UIView!
    weak var tabBarView: UIView!
    var selectedIndex : Int = 0
    weak var selectedController: UIViewController!
    
    
    var items : [ACKTabBarItem]  {
        didSet {
            for index in 0..<items.count {
                items[index].tabBar = self
            }
        }
    }
    
    
    
    required init(items : [ACKTabBarItem]) {
        self.items = items
        self.selectedController = items[selectedIndex].viewController
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func loadView() {
        self.view = UIView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedController.willMoveToParentViewController(self)
        self.addChildViewController(selectedController!)
        selectedController.didMoveToParentViewController(self)
        containerView.addSubview(selectedController.view);
        selectedController.view.frame = self.containerView.bounds
    }
    
    
    
    func selectTab(index: Int) {
        // if let selected = selectedIndex, controller =  selectedController {
        
        if selectedIndex == index {
            self.items[index].viewController.navigationController?.popToRootViewControllerAnimated(true)
            return
        }
        
        //  controller.willMoveToParentViewController(nil)
        //  controller.view.removeFromSuperview()
        //  controller.removeFromParentViewController()
        
        // }
        
        let newC = items[index].viewController
        selectedController.willMoveToParentViewController(nil)
        addChildViewController(newC)
        
        self.transitionFromViewController(selectedController, toViewController: newC, duration: 0.25, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            
            newC.view.frame = self.containerView.bounds
            
            }) { (finished) in
                self.selectedController.removeFromParentViewController()
                newC.didMoveToParentViewController(self)
                self.selectedController = newC
                self.selectedIndex = index
        }
        
        
    }
    
    // func itemForIndex(index: Int) -> ACKTabBarItem {
    
    // }
    
    
    
    
    
}

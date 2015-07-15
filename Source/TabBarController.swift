//
//  TabBarController.swift
//  Rekola
//
//  Created by Dominik Vesely on 19/06/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import SnapKit


protocol ACKTabBarItem {
    
    func select(animated: Bool!) //cant be just Bool, swift compiler bug?
    func deselect()
    
    var view : UIView {get}
    var index : Int! {get set}
    
    var viewController: UIViewController {get set}
    var tabBar : ACKTabBar! {get set}
    
    func didSelect(animated: Bool)
    func didDeselect()
    
    
}

protocol ACKTabBar : class {
    
    func selectTab(index : Int)
    var items : [ACKTabBarItem]! {get set}
    var selectedIndex : Int { get set}
    var selectedController : UIViewController! { get set}
    
}


class TabItem : UIButton, ACKTabBarItem {
    
    var selectedBackgroundColor : UIColor = .rekolaGreenColor()
    var deselectedBackgroundColor : UIColor = .rekolaGreenColor()
    
    required init(controller: UIViewController, images: (UIImage!, UIImage!) ) {
        self.viewController = controller
        super.init(frame: CGRectZero)
        self.setBackgroundImage(UIImage(color:selectedBackgroundColor), forState: UIControlState.Selected | UIControlState.Highlighted)
        self.setBackgroundImage(UIImage(color:deselectedBackgroundColor), forState: UIControlState.Normal)
        self.setImage(images.0, forState: UIControlState.Selected)
        self.setImage(images.1, forState: UIControlState.Normal)
        self.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        self.adjustsImageWhenHighlighted = false
        self.addEventHandler({[weak self] (item) -> Void in
            self?.select(true)
            }, forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: TabBar
    
    var viewController : UIViewController
    var tabBar : ACKTabBar!
    var index : Int!
    var view : UIView  {
        get {
            return self
        }
    }
    
    
    func select(animated: Bool!) { //cant be just Bool, swift compiler bug?
        self.tabBar.selectTab(index)
        self.didSelect(animated)
    }
    
    func deselect() {
        self.didDeselect()
    }
    
    func didSelect(animated: Bool) {
        selected = true
        if(animated) {
            playAnimation()
        }
    }
    
    func didDeselect() {
        selected = false
        
    }
    
    
    func playAnimation() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = NSTimeInterval(0.5)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        self.imageView!.layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
    }
    
}


class ACKTabBarController :UIViewController, ACKTabBar  {
    
    
    weak var containerView: UIView!
    weak var tabBarView: UIView!
    var selectedIndex : Int = 0
    weak var selectedController: UIViewController!
    
    
    var items : [ACKTabBarItem]!
    
    func setUpItems() {
        for index in 0..<items.count {
            items[index].tabBar = self
            items[index].index = index
        }
    }
    
    
    required init(items : [ACKTabBarItem]) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
        setUpItems()
        self.selectedController = items[selectedIndex].viewController
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func loadView() {
        self.view = UIView()
        
        
        let tabbar = UIView()
        self.view.addSubview(tabbar)
        tabbar.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(42)
        }
        
        var last:  UIView? = nil
        for item in items {
            tabbar.addSubview(item.view)
            item.view.snp_makeConstraints({ (make) -> Void in
                make.bottom.top.equalTo(tabbar)
                if let last = last {
                    make.left.equalTo(last.snp_right)
                } else {
                    make.left.equalTo(tabbar)
                }
                make.width.equalTo(tabbar).dividedBy(items.count)
                
            })
            last = item.view
        }
        self.tabBarView = tabbar
        
        let container = UIView()
        view.addSubview(container)
        container.snp_makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(tabbar.snp_top)
        }
        self.containerView = container
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedController.willMoveToParentViewController(self)
        self.addChildViewController(selectedController!)
        containerView.addSubview(selectedController.view);
        selectedController.view.snp_makeConstraints { make in
            make.center.width.height.equalTo(containerView)
        }
        selectedController.didMoveToParentViewController(self)
        //        selectedController.view.frame = self.containerView.bounds
        items[0].didSelect(false)
        
    }
    
    
    
    func selectTab(index: Int) {
        // if let selected = selectedIndex, controller =  selectedController {
        
        if selectedIndex == index {
            self.items[index].viewController.navigationController?.popToRootViewControllerAnimated(true)
            return
        }
        
        let newC = items[index].viewController
        selectedController.willMoveToParentViewController(nil)
        addChildViewController(newC)
        self.items[index].didSelect(true)
        self.items[self.selectedIndex].deselect()
        self.transitionFromViewController(selectedController, toViewController: newC, duration: 0.25, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            newC.view.snp_makeConstraints { make in
                make.center.width.height.equalTo(containerView)
            }
            
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


//
//  ViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 15/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit

class EquipmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let equipmentArray: [Equipment]
    init(equipment: [Equipment]) {
        self.equipmentArray = equipment
        super.init(nibName:nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        self.view = view
        
        let container = UIView()
        view.addSubview(container)
        container.layer.cornerRadius = 5
//        container.layer.borderColor = UIColor.blackColor().CGColor
        container.snp_makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }
        self.container = container
        
        let infoEquipmentLabel = UILabel()
        container.addSubview(infoEquipmentLabel)
        infoEquipmentLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 19)
        infoEquipmentLabel.textColor = .rekolaBlackColor()
        infoEquipmentLabel.snp_makeConstraints { make in
            make.top.equalTo(container).offset(L.verticalSpacing)
            make.left.equalTo(container).offset(L.horizontalSpacing)
        }
        self.infoEquipmentLabel = infoEquipmentLabel
        
        let exitButton = UIButton()
        container.addSubview(exitButton)
        exitButton.snp_makeConstraints { make in
            make.top.equalTo(container).offset(L.verticalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
        }
        self.exitButton = exitButton
        
        let tableView = UITableView()
        container.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.top.equalTo(infoEquipmentLabel.snp_bottom).offset(15)
            make.left.right.equalTo(container)
            make.bottom.equalTo(container).offset(15)
        }
        self.tableView = tableView
    }
    
    weak var container: UIView!
    weak var infoEquipmentLabel: UILabel!
    weak var exitButton: UIButton!
    weak var tableView: UITableView!
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.backgroundColor = .whiteColor()
        
        infoEquipmentLabel.text = NSLocalizedString("BIKEDETAIL_equipment", comment: "")
        
        exitButton.setImage(UIImage(imageIdentifier: .cancelButton), forState: .Normal)
        exitButton.imageView?.contentMode = .ScaleAspectFit
        exitButton.addTarget(self, action: "cancelView", forControlEvents: .TouchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(EquipmentCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func cancelView() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
//    MARK: UITableViewDelegate + DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equipmentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! EquipmentCell
        
        let currentEquipment = equipmentArray[indexPath.row]
        
        let url = NSURL(string: currentEquipment.iconUrl)
        let iv = UIImageView()
        iv.sd_setImageWithURL(url)
        cell.equipmentImageView = iv
        
        cell.descriptionLabel.text = currentEquipment.description
        
        return cell
    }
}

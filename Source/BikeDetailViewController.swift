//
//  BikeDetailViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 09/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import ReactiveCocoa

class BikeDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
	
	
	//TODO: tady mas bike, mozna nema vsechny potrebny property dyztak mi reknes, dodelej pls tuhle screenu
	//TODO: spravit navbar pri animaci back
	let bike : Bike
	init(bike: Bike) {
		self.bike = bike
		super.init(nibName:nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	override func loadView() {
        let view = UIView()
        view.backgroundColor = .whiteColor()
        view.tintColor = .whiteColor()
        self.view = view
        
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 800
        tableView.allowsSelection = false
        tableView.separatorStyle = .None
        tableView.snp_makeConstraints { make in
            make.left.top.right.bottom.equalTo(view)
        }
        self.tableView = tableView
        
        let container = UIView()
        self.container = container
        
        let bikeIV = UIImageView(/*image: UIImage(imageIdentifier: .biggerBorrowBike)*/)
        bikeIV.contentMode = .ScaleAspectFit
        container.addSubview(bikeIV)
        bikeIV.snp_makeConstraints { make in
            make.top.equalTo(container).offset(20)
            make.centerX.equalTo(container)
            make.left.right.equalTo(container).inset(L.contentInsets)
            make.height.equalTo(111)
        }
        self.bikeIV = bikeIV

        let bikeTypeLabel = UILabel()
        container.addSubview(bikeTypeLabel)
        bikeTypeLabel.textAlignment = .Center
        bikeTypeLabel.textColor = .rekolaPinkColor()
        bikeTypeLabel.font = UIFont.systemFontOfSize(14)
        bikeTypeLabel.snp_makeConstraints { make in
            make.top.equalTo(bikeIV.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(container)
        }
        self.bikeTypeLabel = bikeTypeLabel
        
        let bikeNameLabel = UILabel()
        container.addSubview(bikeNameLabel)
        bikeNameLabel.textAlignment = .Center
        bikeNameLabel.font = UIFont.systemFontOfSize(27)
        bikeNameLabel.snp_makeConstraints { make in
            make.top.equalTo(bikeTypeLabel.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.bikeNameLabel = bikeNameLabel
        
        let warningLabel = UILabel()
        container.addSubview(warningLabel)
        warningLabel.textAlignment = .Right
        warningLabel.textColor = .rekolaWarningYellowColor()
        warningLabel.snp_makeConstraints { make in
            make.top.equalTo(bikeNameLabel.snp_bottom).offset(L.verticalSpacing)
            make.centerX.equalTo(container.snp_centerX).offset(10)
        }
        self.warningLabel = warningLabel
        
        let warningIV = UIImageView(image: UIImage(imageIdentifier: .yellowWarning))
        warningIV.contentMode = .ScaleAspectFit
        container.addSubview(warningIV)
        warningIV.snp_makeConstraints { make in
            make.top.equalTo(bikeNameLabel.snp_bottom).offset(L.verticalSpacing)
            make.right.equalTo(warningLabel.snp_left).offset(-L.verticalSpacing)
        }
        self.warningIV = warningIV
        
        let descriptionLabel = Theme.subTitleLabel()
        container.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .Center
        descriptionLabel.snp_makeConstraints{ make in
            make.top.equalTo(warningLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(container).inset(L.contentInsets)
        }
        self.descriptionLabel = descriptionLabel
        
        let line1 = Theme.lineView()
        container.addSubview(line1)
        line1.snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(1)
        }
        
        let lastReturnLabel = UILabel()
        container.addSubview(lastReturnLabel)
        lastReturnLabel.textAlignment = .Center
        lastReturnLabel.font = UIFont.boldSystemFontOfSize(17)
        lastReturnLabel.snp_makeConstraints { make in
            make.top.equalTo(line1.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.lastReturnLabel = lastReturnLabel
        
        let calendarIV = UIImageView(image: UIImage(imageIdentifier: .calendar))
        calendarIV.contentMode = .ScaleAspectFit
        container.addSubview(calendarIV)
        calendarIV.snp_makeConstraints { make in
            make.top.equalTo(lastReturnLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(55)
        }
        
        let dateLabel = Theme.pinkLabel()
        container.addSubview(dateLabel)
        dateLabel.snp_makeConstraints { make in
            make.top.equalTo(lastReturnLabel.snp_bottom).offset(20)
            make.left.equalTo(calendarIV.snp_right).offset(10)
        }
        self.dateLabel = dateLabel
        
        let clockIV = UIImageView(image: UIImage(imageIdentifier: .clock))
        container.addSubview(clockIV)
        clockIV.contentMode = .ScaleAspectFit
        clockIV.snp_makeConstraints { make in
            make.top.equalTo(lastReturnLabel.snp_bottom).offset(20)
            make.left.equalTo(dateLabel.snp_right).offset(40)
        }
        
        let timeLabel = Theme.pinkLabel()
        container.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { make in
            make.top.equalTo(lastReturnLabel.snp_bottom).offset(20)
            make.left.equalTo(clockIV.snp_right).offset(10)
        }
        self.timeLabel = timeLabel
        
        let locationLabel = UILabel()
        container.addSubview(locationLabel)
        locationLabel.textColor = .rekolaGrayTextColor()
        locationLabel.font = UIFont.systemFontOfSize(15)
        locationLabel.textAlignment = .Center
        locationLabel.numberOfLines = 0
        locationLabel.snp_makeConstraints { make in
            make.top.equalTo(dateLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.right.equalTo(container)
        }
        self.locationLabel = locationLabel

        let line2 = Theme.lineView()
        container.addSubview(line2)
        line2.snp_makeConstraints { make in
            make.top.equalTo(locationLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(1)
        }
 
//        following 6 UIImageView will be downloaded from API
        let equipmentLabel = UILabel()
        container.addSubview(equipmentLabel)
        equipmentLabel.textAlignment = .Center
        equipmentLabel.font = UIFont.boldSystemFontOfSize(17)
        equipmentLabel.snp_makeConstraints { make in
            make.top.equalTo(line2.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.bikeEquipmentLabel = equipmentLabel
        
        let mudguardIV = UIImageView(image: UIImage(imageIdentifier: .mudguard))
        mudguardIV.contentMode = .ScaleAspectFit
        container.addSubview(mudguardIV)
        mudguardIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(container).offset(25)
        }
        self.mudguardIV = mudguardIV
        
        let basketIV = UIImageView(image: UIImage(imageIdentifier: .basket))
        basketIV.contentMode = .ScaleAspectFit
        container.addSubview(basketIV)
        basketIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(mudguardIV.snp_right).offset(15)
        }
        self.basketIV = basketIV
        
        let buzzerIV = UIImageView(image: UIImage(imageIdentifier: .buzzer))
        basketIV.contentMode = .ScaleAspectFit
        container.addSubview(buzzerIV)
        buzzerIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(basketIV.snp_right).offset(15)
        }
        self.buzzerIV = buzzerIV
        
        let backlightIV = UIImageView(image: UIImage(imageIdentifier: .backlight))
        backlightIV.contentMode = .ScaleAspectFit
        container.addSubview(backlightIV)
        backlightIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(buzzerIV.snp_right).offset(15)
        }
        self.backlightIV = backlightIV
        
        let frontlightIV = UIImageView(image: UIImage(imageIdentifier: .frontlight))
        frontlightIV.contentMode = .ScaleAspectFit
        container.addSubview(frontlightIV)
        frontlightIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(backlightIV.snp_right).offset(15)
        }
        self.frontlightIV = frontlightIV
        
        let trunkIV = UIImageView(image: UIImage(imageIdentifier: .trunk))
        trunkIV.contentMode = .ScaleAspectFit
        container.addSubview(trunkIV)
        trunkIV.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(frontlightIV.snp_right).offset(15)
        }
        self.trunkIV = trunkIV
        
        let moreInfoButton = TintingButton(titleAndImageTintedWith: .rekolaGreenColor(), activeTintColor: UIColor.whiteColor())
        container.addSubview(moreInfoButton)
        moreInfoButton.layer.borderWidth = 1
        moreInfoButton.layer.borderColor = UIColor.rekolaGreenColor().CGColor
        moreInfoButton.layer.cornerRadius = 5
        moreInfoButton.addTarget(self, action: "viewMoreInfo", forControlEvents: .TouchUpInside)
        moreInfoButton.snp_makeConstraints { make in
            make.top.equalTo(trunkIV.snp_bottom).offset(L.verticalSpacing)
            make.width.equalTo(110)
            make.height.equalTo(44)
            make.centerX.equalTo(container.snp_centerX)
        }
        self.moreInfoButton = moreInfoButton
        
        let line3 = Theme.lineView()
        container.addSubview(line3)
        line3.snp_makeConstraints { make in
            make.top.equalTo(moreInfoButton.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(1)
        }
        
        let problemsLabel = UILabel()
        container.addSubview(problemsLabel)
        problemsLabel.textAlignment = .Center
        problemsLabel.font = UIFont.boldSystemFontOfSize(17)
        problemsLabel.snp_makeConstraints { make in
            make.top.equalTo(line3.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.problemsLabel = problemsLabel
        
        let addProblemButton = Theme.pinkButton()
        container.addSubview(addProblemButton)
        addProblemButton.snp_makeConstraints { make in
            make.top.equalTo(problemsLabel.snp_bottom).offset(20)
            make.left.equalTo(container).offset(L.horizontalSpacing)
            make.right.equalTo(container).offset(-L.horizontalSpacing)
            make.height.equalTo(44)
        }
        self.addProblemButton = addProblemButton
    }
    
    weak var tableView: UITableView!
    var container: UIView!
    weak var bikeIV: UIImageView!
    var bikeTypeLabel: UILabel!
    var bikeNameLabel: UILabel!
    var warningIV: UIImageView!
    var warningLabel: UILabel!
    var descriptionLabel: UILabel!
    var lastReturnLabel: UILabel!
    var timeLabel: UILabel!
    var dateLabel: UILabel!
    var locationLabel: UILabel!
    var bikeEquipmentLabel: UILabel!
    var mudguardIV: UIImageView!
    var basketIV: UIImageView!
    var buzzerIV: UIImageView!
    var backlightIV: UIImageView!
    var frontlightIV: UIImageView!
    var trunkIV: UIImageView!
    var moreInfoButton: TintingButton!
    var problemsLabel: UILabel!
    var addProblemButton: UIButton!
    var infoEquipmentLabel: UILabel!
    
    var bikeIssues: [BikeIssue] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let cellIdentifier = "cell"
    let problemCellIdentifier = "ProblemCell"
    var isUnmovable = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.tintColor = .rekolaPinkColor()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.registerClass(ProblemCell.self, forCellReuseIdentifier: problemCellIdentifier)
        
        deleteLineUnderNavBar()
        
        let lockButton = UIBarButtonItem(image: UIImage(imageIdentifier: .detailLock), style: .Plain, target: self, action: "lockBike:")
        self.navigationItem.rightBarButtonItem = lockButton

        let bikeImageData = NSData(contentsOfURL: bike.imageURL)
        bikeIV.image = UIImage(data: bikeImageData!)
        
        bikeTypeLabel.text = bike.type.uppercaseString
        
        bikeNameLabel.text = bike.name
        
        let warning = setWarningLabelText()
        warningLabel.text = warning.0
        warningIV.image = warning.1
        if isUnmovable {
            warningLabel.textColor = .rekolaWarningRedColor()
        }
        
        descriptionLabel.text = bike.description
        
        lastReturnLabel.text = NSLocalizedString("BIKEDETAIL_lastReturn", comment: "")
        
        let dateAndTime = formatDateAndTime(bike.lastSeen)
        
        dateLabel.text = dateAndTime.0
        timeLabel.text = dateAndTime.1
        
        locationLabel.text = bike.location.note
        
        bikeEquipmentLabel.text = NSLocalizedString("BIKEDETAIL_equipment", comment: "")

        moreInfoButton.setTitle(NSLocalizedString("BIKEDETAIL_moreInfo", comment: ""), forState: .Normal)
        
        problemsLabel.text = NSLocalizedString("BIKEDETAIL_problems", comment: "")
        
        addProblemButton.setTitle(NSLocalizedString("BIKEDETAIL_addProblem", comment: ""), forState: .Normal)
        addProblemButton.addTarget(self, action: "addProblemSegue", forControlEvents: .TouchUpInside)
        
        loadIssues()
    }
    
    func deleteLineUnderNavBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
    }
    
    func setWarningLabelText() -> (String, UIImage) {
        if bike.operational && bike.issues.count > 0 {
            return (NSLocalizedString("BIKEDETAIL_drivableWithProblems", comment: ""),UIImage(imageIdentifier: .yellowWarning))
        } else if !bike.operational {
            self.isUnmovable = true
            return (NSLocalizedString("BIKEDETAIL_undrivable", comment: ""),UIImage(imageIdentifier: .redWarning))
        }
        return ("", UIImage())
    }
    
    func formatDateAndTime(date: NSDate) -> (String, String) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        let stringDate = dateFormatter.stringFromDate(date)
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let stringTime = timeFormatter.stringFromDate(date)
        
        return (stringDate, stringTime)
    }
    
//    API calling
    let issuesRequestPending = MutableProperty(false)
    func loadIssues() {
        issuesRequestPending.value = true
        let test = API.myBikeIssue(id: bike.id).start(error: { error in
                self.issuesRequestPending.value = false
                self.handleError(error)
            }, next: {
                self.bikeIssues = $0
            }
    )
    }
    
//    TODO: what this button do?
    func lockButton() {
        
    }
    
    func viewMoreInfo() {
        let vc = EquipmentViewController()
        presentPopupViewController(vc, completion: nil)
    }
    
    func addProblemSegue() {
		let vc = AddProblemViewController(bike: bike)
        showViewController(vc, sender: nil)
    }
    
//    navigationBar settings (when scrolling)
    func scrollViewDidScroll(scrollview: UIScrollView) {
        let color = UIColor.rekolaGreenColor()
        let changePoint = 50 as CGFloat
        let offsetY = tableView.contentOffset.y
        
        if offsetY > changePoint {
            let alpha = min(1, 1-((changePoint + 64 - offsetY)/64))
            self.navigationController?.navigationBar .lt_setBackgroundColor(color .colorWithAlphaComponent(alpha))
            self.navigationController?.navigationBar.tintColor = .whiteColor()
            
        } else {
            self.navigationController?.navigationBar .lt_setBackgroundColor(color .colorWithAlphaComponent(0))
            self.navigationController?.navigationBar.tintColor = .rekolaPinkColor()
            deleteLineUnderNavBar()
        }
    }
    
     override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar .lt_reset()
    }
    
//    MARK: UITableViewDelegate + UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return bikeIssues.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell //for section 0
        let problemCell = tableView.dequeueReusableCellWithIdentifier(problemCellIdentifier) as! ProblemCell //for section 1
        
        
        if indexPath.section == 0 {
            cell.contentView.addSubview(container)
            container.snp_makeConstraints { make in
                make.edges.equalTo(cell.contentView)
            }
            return cell
        } else {
//            format
            problemCell.descriptionLabel.numberOfLines = 0
            problemCell.descriptionLabel.textColor = .grayColor()
            problemCell.textLabel?.font = UIFont.boldSystemFontOfSize(14)
            
//            dateFormat
            let date = bikeIssues[indexPath.row].updates[0].issuedAt
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = " / dd.MM.YYYY / HH:mm"
            let dateString = dateFormatter.stringFromDate(date)
            
//            setting text
            let issue = bikeIssues[indexPath.row]
        
            problemCell.typeLabel.text = issue.title
            problemCell.nameLabel.text = issue.updates[0].author + dateString
            problemCell.descriptionLabel.text = issue.updates[0].description
            
            return problemCell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 //one section is required for the upper part of screen, rest is for bike issues
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 770
        }
        return 100
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return ""
//    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section >= 1 {
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.contentView.backgroundColor = .whiteColor()
            header.textLabel.textColor = .rekolaGreenColor()
            header.textLabel.font = UIFont.boldSystemFontOfSize(16)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section != 0 {
//            return 18
//        }
        return 0
    }
	
	func lockBike(sender: AnyObject?) {
		if let tabBar = UIApplication.sharedApplication().keyWindow?.rootViewController as? ACKTabBar {
			if (tabBar.selectedIndex != 0) {
				tabBar.selectTab(0)
			}else{
				navigationController?.popViewControllerAnimated(true)
			}
		}
        }
}
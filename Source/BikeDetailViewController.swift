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

class BikeDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource  {

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
        tableView.estimatedRowHeight = 620
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
        bikeTypeLabel.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 14)
        bikeTypeLabel.snp_makeConstraints { make in
            make.top.equalTo(bikeIV.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(L.horizontalSpacing)
            make.right.equalTo(-L.horizontalSpacing)
        }
        self.bikeTypeLabel = bikeTypeLabel
        
        let bikeNameLabel = UILabel()
        container.addSubview(bikeNameLabel)
        bikeNameLabel.textAlignment = .Center
        bikeNameLabel.textColor = .rekolaBlackColor()
        bikeNameLabel.numberOfLines = 0
        bikeNameLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 27)
        bikeNameLabel.snp_makeConstraints { make in
            make.top.equalTo(bikeTypeLabel.snp_bottom).offset(20)
            make.left.equalTo(L.horizontalSpacing)
            make.right.equalTo(-L.horizontalSpacing)
        }
        self.bikeNameLabel = bikeNameLabel
        
        let warningLabel = UILabel()
        container.addSubview(warningLabel)
        warningLabel.textAlignment = .Right
        warningLabel.textColor = .rekolaWarningYellowColor()
        warningLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 17)
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
        descriptionLabel.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 13)
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
        
        let equipmentLabel = UILabel()
        container.addSubview(equipmentLabel)
        equipmentLabel.textAlignment = .Center
        equipmentLabel.textColor = .rekolaBlackColor()
        equipmentLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 17)
        equipmentLabel.snp_makeConstraints { make in
            make.top.equalTo(line1.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.bikeEquipmentLabel = equipmentLabel
        
        let layoutForCollectionView = UICollectionViewFlowLayout()
        layoutForCollectionView.scrollDirection = UICollectionViewScrollDirection.Horizontal
//        layoutForCollectionView.minimumInteritemSpacing = CGFloat(collectionViewSpacing)
        layoutForCollectionView.minimumLineSpacing = CGFloat(collectionViewSpacing)
        
        let equipmentCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layoutForCollectionView)
        container.addSubview(equipmentCollectionView)
        equipmentCollectionView.backgroundColor = .whiteColor()
        equipmentCollectionView.indicatorStyle = UIScrollViewIndicatorStyle.White
        equipmentCollectionView.snp_makeConstraints { make in
            make.top.equalTo(equipmentLabel.snp_bottom).offset(15)
            make.left.right.equalTo(0)
            make.height.equalTo(32)
        }
        self.equipmentCollectionView = equipmentCollectionView
        
        let moreInfoButton = TintingButton(titleAndImageTintedWith: .rekolaGreenColor(), activeTintColor: UIColor.whiteColor())
        container.addSubview(moreInfoButton)
        moreInfoButton.layer.borderWidth = 1
        moreInfoButton.layer.borderColor = UIColor.rekolaGreenColor().CGColor
        moreInfoButton.layer.cornerRadius = 5
        moreInfoButton.titleLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
        moreInfoButton.addTarget(self, action: "viewMoreInfo", forControlEvents: .TouchUpInside)
        moreInfoButton.snp_makeConstraints { make in
            make.top.equalTo(equipmentCollectionView.snp_bottom).offset(L.verticalSpacing)
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
        problemsLabel.textColor = .rekolaBlackColor()
        problemsLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 17)
        problemsLabel.snp_makeConstraints { make in
            make.top.equalTo(line3.snp_bottom).offset(20)
            make.left.right.equalTo(container)
        }
        self.problemsLabel = problemsLabel
        
        let noProblemLabel = UILabel()
        container.addSubview(noProblemLabel)
        noProblemLabel.textAlignment = .Center
        noProblemLabel.textColor = .grayColor()
        noProblemLabel.font = UIFont(name: Theme.SFFont.Medium.rawValue, size: 14)
        noProblemLabel.text = NSLocalizedString("BIKEDETAIL_noProblems", comment: "")
        noProblemLabel.hidden = true
        noProblemLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(problemsLabel.snp_bottom).offset(15)
            make.left.right.equalTo(container).inset(L.contentInsets)
        }
        self.noProblemLabel = noProblemLabel
        
        let addProblemButton = Theme.pinkButton()
        container.addSubview(addProblemButton)
        addProblemButton.snp_makeConstraints { make in
            make.top.equalTo(problemsLabel.snp_bottom).offset(20)
            make.left.right.equalTo(container).inset(L.contentInsets)
            make.height.equalTo(44)
//            make.bottom.equalTo(0).inset(L.contentInsets)
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
    var equipmentCollectionView: UICollectionView!
    var moreInfoButton: TintingButton!
    var problemsLabel: UILabel!
    var noProblemLabel: UILabel!
    var addProblemButton: UIButton!
    var infoEquipmentLabel: UILabel!
    var bikeIssues: [BikeIssue] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var sortedBikeIssues: [[BikeIssue]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var typeOfProblem: Issues? {
        didSet {
            tableView.reloadData()
        }
    }
    let cellIdentifier = "cell"
    let problemCellIdentifier = "ProblemCell"
    let collectionIdentifier = "CollectionIdentifier"
    let collectionViewSpacing = 20
    var isUnmovable = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.registerClass(ProblemCell.self, forCellReuseIdentifier: problemCellIdentifier)
        
        equipmentCollectionView.delegate = self
        equipmentCollectionView.dataSource = self
        
        equipmentCollectionView.registerClass(EquipmentCollectionViewCell.self, forCellWithReuseIdentifier: collectionIdentifier)
        
        deleteLineUnderNavBar()
        
        let lockButton = UIBarButtonItem(image: UIImage(imageIdentifier: .detailLock), style: .Plain, target: self, action: "lockBike:")
        self.navigationItem.rightBarButtonItem = lockButton
        
        if let bikeImageData = NSData(contentsOfURL: bike.imageURL) {
            bikeIV.image = UIImage(data: bikeImageData)
        }
        bikeTypeLabel.text = bike.type.uppercaseString
        
        bikeNameLabel.text = bike.name
        
        let warning = setWarningLabelText()
        warningLabel.text = warning.0
        warningIV.image = warning.1
        if isUnmovable {
            warningLabel.textColor = .rekolaWarningRedColor()
        }
        
        descriptionLabel.text = bike.description
        
        bikeEquipmentLabel.text = NSLocalizedString("BIKEDETAIL_equipment", comment: "")
        
        moreInfoButton.setTitle(NSLocalizedString("BIKEDETAIL_moreInfo", comment: ""), forState: .Normal)
        
        problemsLabel.text = NSLocalizedString("BIKEDETAIL_problems", comment: "")
        
        if bike.issues.count == 0 {
            noProblemLabel.hidden = false
            addProblemButton.snp_remakeConstraints{ make in
                make.top.equalTo(noProblemLabel.snp_bottom).offset(10)
                make.left.right.equalTo(container).inset(L.contentInsets)
                make.height.equalTo(44)
            }
            container.setNeedsLayout()
        }
        
        addProblemButton.setTitle(NSLocalizedString("BIKEDETAIL_addProblem", comment: ""), forState: .Normal)
        addProblemButton.addTarget(self, action: "addProblemSegue", forControlEvents: .TouchUpInside)
        
        loadIssues()
        loadProblems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController!.navigationBar.tintColor = .rekolaPinkColor()
////        self.navigationController!.navigationBar.backgroundColor = .whiteColor()
////        self.navigationController!.navigationBar.barTintColor = .whiteColor()
        
        deleteLineUnderNavBar()

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
    
    func sortProblems() {
        var sortedIssues = bikeIssues
        sortedIssues.sort({$0.type < $1.type})
        
//        creating sortedBikeIssues
        let unrealBike = BikeIssue(id: 0, title: "", status: "", type: -1, updates: [])
        var prevElem = unrealBike //unrealBike nemuze nastat (type -1)
        var indexOuterArray = -1 //index for outer array
        for index in 0..<sortedIssues.count {
            if sortedIssues[index].type == prevElem.type {
                sortedBikeIssues[indexOuterArray].append(sortedIssues[index])
            } else if sortedIssues[index].type > prevElem.type {
                prevElem = sortedIssues[index]
                sortedBikeIssues.append([])
                indexOuterArray++ //posun do dalsiho pole
                sortedBikeIssues[indexOuterArray].append(sortedIssues[index])
            } else {
//                nenastane (mame setridene pole od nejmensiho prvku
            }
        }
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
                self.sortProblems()
            }
        )
    }
    
    let problemRequestPending = MutableProperty(false)
    func loadProblems() {
        problemRequestPending.value = true
        let test = API.defaultProblems().start( error: { error in
            self.problemRequestPending.value = false
            self.handleError(error)
            }, next: {
                self.typeOfProblem = $0
        })
    }
    

    
    func viewMoreInfo() {
        let arrayOfEquipment = bike.equipment
        let vc = EquipmentViewController(equipment: arrayOfEquipment)
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
            self.navigationController?.navigationBar.barTintColor = .rekolaGreenColor()
            self.navigationController?.navigationBar.tintColor = .whiteColor()
            
            let lockButton = UIBarButtonItem(image: UIImage(imageIdentifier: .DetailLockScroll), style: .Plain, target: self, action: "lockBike:")
            self.navigationItem.rightBarButtonItem = lockButton
            self.navigationItem.title = bike.name.uppercaseString
            UIApplication.sharedApplication().statusBarStyle = .LightContent
        } else {
            self.navigationController?.navigationBar .lt_setBackgroundColor(color .colorWithAlphaComponent(0))
            self.navigationController?.navigationBar.tintColor = .rekolaPinkColor()
            self.navigationController?.navigationBar.barTintColor = .whiteColor()
            UIApplication.sharedApplication().statusBarStyle = .Default
            let lockButton = UIBarButtonItem(image: UIImage(imageIdentifier: .detailLock), style: .Plain, target: self, action: "lockBike:")
            self.navigationItem.rightBarButtonItem = lockButton
            self.navigationItem.title = ""
            
            deleteLineUnderNavBar()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar .lt_reset()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        settings fot collectionView layout
        let padding = equipmentCollectionView.bounds.size.width - CGFloat(bike.equipment.count * (EquipmentCollectionViewCell.imageWidth) + (bike.equipment.count - 1)*collectionViewSpacing)
                
        if let layout = equipmentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(0, padding/2, 0, 0)
        }
    }
    
    //    MARK: UITableViewDelegate + UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            for index in 0..<sortedBikeIssues.count {
                if section-1 == index {
                    return sortedBikeIssues[index].count
                }
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func problemDateFormat(date: NSDate, name: String) -> NSAttributedString {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = " / dd.MM.YYYY / HH:mm"
        let dateString = dateFormatter.stringFromDate(date)
        
        let text = name + dateString
        let firstSlashIndex = count(name) + 1
        let secondSlashIndex = count(name) + 14
        
        let atribute = NSMutableAttributedString(string: text)
        atribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.rekolaPinkColor(), range: NSRange(location: firstSlashIndex, length: 1))
        atribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.rekolaPinkColor(), range: NSRange(location: secondSlashIndex, length: 1))
        
        return atribute
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell //for section 0
        let problemCell = tableView.dequeueReusableCellWithIdentifier(problemCellIdentifier) as! ProblemCell//for section 1
        
        
        if indexPath.section == 0 {
            cell.contentView.addSubview(container)
            container.snp_makeConstraints { make in
                make.edges.equalTo(cell.contentView)
            }
            return cell
        } else {
            let issue = sortedBikeIssues[indexPath.section - 1][indexPath.row]
            //            dateFormat
            let date = sortedBikeIssues[indexPath.section - 1][indexPath.row].updates[0].issuedAt
            let name = issue.updates[0].author

            //            setting text
            problemCell.nameLabel.attributedText = problemDateFormat(date, name: name)
            problemCell.descriptionLabel.text = issue.updates[0].description
            
            return problemCell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sortedBikeIssues.count + 1 //one section is required for the upper part of screen, rest is for bike issues
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 620
        }
        return 55
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            for index in 0..<sortedBikeIssues.count {
                if section-1 == index {
                    return sortedBikeIssues[index][0].title
                }
            }
        }
        return ""
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section >= 1 {
            let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
            header.contentView.backgroundColor = .whiteColor()
            header.textLabel.textColor = .rekolaGreenColor()
            header.textLabel.font = UIFont(name: Theme.SFFont.Bold.rawValue, size: 17)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 40
        }
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
    
//    MARK: UICollectionViewDelegate
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 33, height: 33)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionIdentifier, forIndexPath: indexPath) as! EquipmentCollectionViewCell
        
        let url = NSURL(string: bike.equipment[indexPath.row].iconUrl)
        
        cell.equipmentImage.sd_setImageWithURL(url)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bike.equipment.count
    }
}
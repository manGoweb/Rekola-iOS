//
//  ProblemsViewController.swift
//  Rekola
//
//  Created by Daniel Brezina on 13/07/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import ReactiveCocoa

protocol ProblemsViewControllerProtocol: class {
    func addProblemToTextField(controller: ProblemsViewController, problem: AddIssue)
}

class ProblemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .rekolaPinkColor()
        self.view = view
        
        let cancelButton = UIButton()
        view.addSubview(cancelButton)
        cancelButton.setImage(UIImage(imageIdentifier: .cancelButton), forState: .Normal)
        cancelButton.snp_makeConstraints { make in
            make.top.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
        }
        self.cancelButton = cancelButton
        
        
        let tableView = UITableView()
        view.addSubview(tableView)
        tableView.separatorColor = .whiteColor()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorStyle = .SingleLine
        tableView.backgroundColor = .rekolaPinkColor()
        tableView.snp_makeConstraints { make in
            make.top.equalTo(cancelButton.snp_bottom).offset(L.verticalSpacing)
            make.left.equalTo(view).offset(L.horizontalSpacing)
            make.right.equalTo(view).offset(-L.horizontalSpacing)
            make.bottom.equalTo(view).offset(L.verticalSpacing)
        }
        self.tableView = tableView
    }
    
    weak var cancelButton: UIButton!
    weak var tableView: UITableView!
    weak var delegate: ProblemsViewControllerProtocol?
    var problems: Issues? {
        didSet {
            tableView.reloadData()
        }
    }
    let cellIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        cancelButton.addTarget(self, action: "cancelView", forControlEvents: .TouchUpInside)
        
        loadProblems()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func cancelView() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    API calling
    let problemRequestPending = MutableProperty(false)
    func loadProblems() {
        problemRequestPending.value = true
        let test = API.defaultProblems().start( error: { error in
                self.problemRequestPending.value = false
                self.handleError(error)
            }, next: {
                self.problems = $0
        })
    }
    
//    MARK: UITabelViewDelegate + UITableViewDataSource
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset.right = 15.0
        cell.preservesSuperviewLayoutMargins = false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let issues = problems{
            return issues.issues.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UITableViewCell
        if let issue = problems {
            cell.selectionStyle = .None
            cell.textLabel!.text = issue.issues[indexPath.row].title
            cell.textLabel?.textColor = .whiteColor()
            cell.textLabel?.font = UIFont(name: Theme.SFFont.Regular.rawValue, size: 17)
            cell.backgroundColor = .rekolaPinkColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let issue = problems {
            let newIssue = AddIssue(id: issue.issues[indexPath.row].id, title: issue.issues[indexPath.row].title)
            
            delegate?.addProblemToTextField(self, problem: newIssue)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

}

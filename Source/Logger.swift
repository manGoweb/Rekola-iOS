//
//  Logger.swift
//  ProjectName
//
//  Created by Petr Šíma on Jun/25/15.
//  Copyright (c) 2015 Ackee s.r.o. All rights reserved.
//

import Foundation
import CocoaLumberjack
import CocoaLumberjackSwift


private var fileLogger = DDFileLogger()
private var isConfigured = false
private func configure() {
	defaultDebugLevel = .Debug
	setenv("XcodeColors", "YES", 0)
	fileLogger.rollingFrequency = 60 * 60 * 24
	fileLogger.maximumFileSize = (1024 * 64); // 64 KByte
	fileLogger.logFormatter = LongLogFormatter()
	DDLog.addLogger(fileLogger, withLevel: .Info)
	let xcodeLogger = DDTTYLogger.sharedInstance()
	xcodeLogger.colorsEnabled = true
	xcodeLogger.setForegroundColor(UIColor.whiteColor(), backgroundColor: nil, forFlag:DDLogFlag.Info)
	xcodeLogger.setForegroundColor(UIColor(hexString: "#FF69B4"), backgroundColor: nil, forFlag: DDLogFlag.Debug)
	xcodeLogger.logFormatter = LongLogFormatter()
	DDLog.addLogger(xcodeLogger)
	
	if Environment.scheme == .AdHoc{
		if let window = UIApplication.sharedApplication().keyWindow {
			let rec = UITapGestureRecognizer(actionBlock: { rec in
				if let rootVC = window.rootViewController {
					let logVC = LogViewController()
					let navC = UINavigationController(rootViewController: logVC)
					rootVC.presentViewController(navC, animated: true, completion: nil)
				}else{
					logE("window detected debug gesture, but there is no root view controller.")
				}
			})
			rec.numberOfTouchesRequired = 4
			rec.numberOfTapsRequired = 2
			rec.cancelsTouchesInView = false
			rec.delaysTouchesBegan = false
			rec.delaysTouchesEnded = false
			window.addGestureRecognizer(rec)
		}else{
			logE("cant configure log gesture because there is no window")
		}
	}
	
	isConfigured = true
}

enum Logger {
	static var loggingIsAsync = true
}

func logA(@autoclosure debugText: () -> String, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
	if(!isConfigured) { configure() }
	SwiftLogMacro(Logger.loggingIsAsync, .Error, flag: .Error, context: 0, file: file, function: function, line: line, tag: nil, string: debugText)
	return
}

func log(@autoclosure logText: () -> String, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
	if(!isConfigured) { configure() }
	SwiftLogMacro(Logger.loggingIsAsync, .Info, flag: .Info, context: 0, file: file, function: function, line: line, tag: nil, string: logText)
}

func logE(@autoclosure errorText: () -> String, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
	if(!isConfigured) { configure() }
	SwiftLogMacro(Logger.loggingIsAsync, .Warning, flag: .Warning, context: 0, file: file, function: function, line: line, tag: nil, string: errorText)
}

func logD(@autoclosure debugText: () -> String, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) {
	if(!isConfigured) { configure() }
	SwiftLogMacro(Logger.loggingIsAsync, .Debug, flag: .Debug, context: 0, file: file, function: function, line: line, tag: nil, string: debugText)
}


class LongLogFormatter : NSObject, DDLogFormatter {
 @objc func formatLogMessage(logMessage: DDLogMessage!) -> String! {
		return "\(logMessage.file.lastPathComponent.stringByDeletingPathExtension).\(logMessage.function).line\(logMessage.line): \(logMessage.message)"
	}
}

private class LogViewController : UIViewController {
	private override func loadView() {
		let view = UIView()
		view.backgroundColor = .whiteColor()
		view.opaque = true
		self.view = view
		let tv = UITextView()
		view.addSubview(tv)
		tv.snp_makeConstraints { make in
			make.left.right.equalTo(view)
			make.top.equalTo(snp_topLayoutGuideBottom)
			make.bottom.equalTo(keyboardLayoutGuide)
		}
		textView = tv
	}
	
	weak var textView : UITextView!
	
	private func getLogWithMaxLength(length: Int) -> String {
		if let file = fileLogger.logFileManager.sortedLogFileInfos().last as? DDLogFileInfo {
			let path = file.filePath
			let url = NSURL(fileURLWithPath: path)!
			let data = NSData(contentsOfURL: url)!
			let text = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
			let l = min(length, count(text))
			let trimmed = text.substringWithRange(Range<String.Index>(start: advance(text.endIndex, -l), end: text.endIndex))
			return trimmed ?? ""
		}
		return ""
	}
	
	private override func viewDidLoad() {
		super.viewDidLoad()
		let t = getLogWithMaxLength(10000)
		textView.text = t
		textView.becomeFirstResponder()
		UIPasteboard.generalPasteboard().string = t
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
	}
	
	private func cancel(sender: AnyObject?) {
		navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
	}
	
	private override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
}
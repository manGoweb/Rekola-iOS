//
//  ReturnBikeViewController.h
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "LocateViewController.h"

@interface ReturnBikeViewController : BaseViewController <LocateViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *codeLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton *returnButton;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UITextField *codeField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *webIndicatorView;

@end

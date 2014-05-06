//
//  SuccessViewController.h
//  rekola
//
//  Created by Martin Banas on 06/05/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"

@interface SuccessViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

- (IBAction)done:(id)sender;

@end

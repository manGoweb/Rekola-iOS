//
//  BikeDetailViewController.h
//  rekola
//
//  Created by Martin Banas on 28/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"

@interface BikeDetailViewController : BaseViewController

@property (nonatomic, strong) NSString *urlPath;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;

@end

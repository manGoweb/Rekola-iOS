//
//  BikeDetailViewController.m
//  rekola
//
//  Created by Martin Banas on 28/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BikeDetailViewController.h"

@implementation BikeDetailViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.title = [ContentManager manager].usingBike.name ?: NSLocalizedString(@"Bike Detail", @"Bar button title in navigation bar");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: missing url
    _urlPath = @"https://dl.dropboxusercontent.com/u/43851739/index.html";
    [self reloadData];
}

- (void)reloadData {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlPath] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.userInteractionEnabled = NO;
    _indicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.userInteractionEnabled = YES;
    _indicatorView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _indicatorView.hidden = YES;
    
    if (error.code != -999) {
        [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Title in alert button") otherButtonTitles:nil, nil] showWithCompletionBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL result = YES;
    BOOL headerIsPresent = ([[request allHTTPHeaderFields] objectForKey:@"X-Api-Key"] != nil);
    if (!headerIsPresent) {
        NSURL *url = [request URL];
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
        
        [request addValue:[APIManager manager].accessToken forHTTPHeaderField:@"X-Api-Key"];
        [_webView loadRequest:request];
        result = NO;
        
    }
    return result;
}

@end

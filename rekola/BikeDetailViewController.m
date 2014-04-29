//
//  BikeDetailViewController.m
//  rekola
//
//  Created by Martin Banas on 28/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BikeDetailViewController.h"

@implementation BikeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlPath = @"https://dl.dropboxusercontent.com/u/43851739/index.html";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
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
    
    // TODO:
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Title in alert button") otherButtonTitles:nil, nil] showWithCompletionBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL result = NO;
    NSString *query = request.URL.absoluteString;
    if ([query rangeOfString:@"navigate_back=true"].location == NSNotFound) {
        result = YES;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return result;
}


@end

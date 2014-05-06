//
//  ProfileViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsCell.h"

@implementation ProfileViewController {
    NSString *_urlPath;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.title = NSLocalizedString(@"Profile", @"Title in nav & tab controller");
        self.navigationController.tabBarItem.title = self.title;
        
        // TODO: missing proper page url
        _urlPath = @"https://dl.dropboxusercontent.com/u/43851739/logout.html";
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tabbar_ic_profile_active.png"] selectedImage:[[UIImage imageNamed:@"tabbar_ic_profile_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlPath] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [_webView loadRequest:request];
}

#pragma mark - Actions

- (IBAction)logout:(id)sender {
    [self showLogoutDialog];
}

#pragma mark - Private methods

- (void)showLogoutDialog {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to log out?", @"Title in Action Sheet") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Button in Action Sheet") destructiveButtonTitle:NSLocalizedString(@"Log Out", @"Button in Action Sheet") otherButtonTitles:nil, nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
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
        [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Title in alert button") otherButtonTitles:nil, nil] show];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL result = NO;
    NSString *query = request.URL.absoluteString;
    if ([query rangeOfString:@"log_out"].location == NSNotFound) {
        
        BOOL headerIsPresent = ([[request allHTTPHeaderFields] objectForKey:@"X-Api-Key"] != nil);
        if (!headerIsPresent) {
            result = NO;
            NSURL *url = [request URL];
            
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
            
            [request addValue:[APIManager manager].accessToken forHTTPHeaderField:@"X-Api-Key"];
            [_webView loadRequest:request];

        } else {
            result = YES;
        }
        
    } else {
        [self showLogoutDialog];
    }
    return result;
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[ContentManager manager] logout];
    }
}


@end

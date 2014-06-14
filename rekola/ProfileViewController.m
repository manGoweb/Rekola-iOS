/**
 * This source code can be used only for purposes specified by the given Apache License.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Copyright 2014 Inmite s.r.o. (www.inmite.eu)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "ProfileViewController.h"
#import "SettingsCell.h"
#import "UIWebView+AFNetworking.h"

@implementation ProfileViewController {
    NSString *_urlPath;
    
    struct {
        unsigned int errorState:1;
    } _flags;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.title = NSLocalizedString(@"Profile", @"Title in nav & tab controller");
        self.navigationController.tabBarItem.title = self.title;
        
        _urlPath = [NSString stringWithFormat:@"%@/accounts/mine/profile-webview",RekolaAPIURLString];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tabbar_ic_profile_active.png"] selectedImage:[[UIImage imageNamed:@"tabbar_ic_profile_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logOutButton.title = NSLocalizedString(@"Log Out", @"Bar button title in navigation bar");
    _errorLabel.text = NSLocalizedString(@"Something went wrong.", @"A label text somewhere on the screen");
    _errorLabel.hidden = YES;
    
    _webView.requestSerializer = [APIManager manager].requestSerializer;
    _flags.errorState = 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData {
    if (_flags.errorState == 1) {
        [self loadURL:[NSURL URLWithString:_urlPath]];
    }
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

- (void)loadURL:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    
    [request addValue:[APIManager manager].accessToken forHTTPHeaderField:@"X-Api-Key"];
    
    __weak __typeof(self)weakSelf = self;
    [_webView loadRequest:request progress:nil success:nil failure:^(NSError *error) {
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (error.code != -999) {
                strongSelf.errorLabel.hidden = NO;
                strongSelf->_flags.errorState = 1;
                strongSelf.indicatorView.hidden = YES;
            }
        }
    }];
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.userInteractionEnabled = NO;
    _indicatorView.hidden = NO;
    _errorLabel.hidden = YES;
    _flags.errorState = 0;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.userInteractionEnabled = YES;
    _indicatorView.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL result = YES;
    NSString *query = request.URL.absoluteString;
    if (query) {
        if ([query rangeOfString:@"log_out"].location == NSNotFound) {
            //
        } else {
            result = NO;
            [self showLogoutDialog];
        }
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

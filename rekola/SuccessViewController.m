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

#import "SuccessViewController.h"
#import "UIWebView+AFNetworking.h"

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _errorLabel.text = NSLocalizedString(@"Something went wrong.", @"A label text somewhere on the screen");
    _errorLabel.hidden = YES;
    
    _webView.requestSerializer = [APIManager manager].requestSerializer;
    [self reloadData];
}

- (void)reloadData {
    [self loadURL:[NSURL URLWithString:_urlPath]];
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private methods

- (void)loadURL:(NSURL *)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    
    [request addValue:[APIManager manager].accessToken forHTTPHeaderField:@"X-Api-Key"];
    
    __weak __typeof(self)weakSelf = self;
    [_webView loadRequest:request progress:nil success:nil failure:^(NSError *error) {
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            if (error.code != -999) {
                strongSelf.errorLabel.hidden = NO;
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.userInteractionEnabled = YES;
    _indicatorView.hidden = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL result = YES;
    NSString *query = request.URL.absoluteString;
    if (query) {
        if ([query rangeOfString:@"dismiss_view"].location == NSNotFound) {
            //
        } else {
            result = NO;
            [self done:nil];
        }
    }
    return result;
}

@end

/**
 *  Copyright (c) 2014, Inmite s.r.o. (www.inmite.eu).
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Inmite s.r.o.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

#import "SuccessViewController.h"

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _errorLabel.text = NSLocalizedString(@"Something went wrong so the page failed to load.", @"A label text somewhere on the screen");
    _errorLabel.hidden = YES;
    
    [self reloadData];
}

- (void)reloadData {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlPath] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
    [_webView loadRequest:request];
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _indicatorView.hidden = YES;
    
    if (error.code != -999) {
        [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Title in alert button") otherButtonTitles:nil, nil] showWithCompletionBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        _errorLabel.hidden = NO;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL result = YES;
    NSString *query = request.URL.absoluteString;
    if (query) {
        if ([query rangeOfString:@"dismiss_view"].location == NSNotFound) {
            
            BOOL headerIsPresent = ([[request allHTTPHeaderFields] objectForKey:@"X-Api-Key"] != nil);
            if (!headerIsPresent) {
                result = NO;
                NSURL *url = [request URL];
                
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15];
                
                [request addValue:[APIManager manager].accessToken forHTTPHeaderField:@"X-Api-Key"];
                [_webView loadRequest:request];
            }
            
        } else {
            result = NO;
            [self done:nil];
        }
    }
    return result;
}

@end

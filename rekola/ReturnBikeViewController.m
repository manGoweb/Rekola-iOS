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

#import "ReturnBikeViewController.h"
#import "BikeDetailViewController.h"
#import "SuccessViewController.h"
#import "UIWebView+AFNetworking.h"

@implementation ReturnBikeViewController {
    NSString *_urlPath;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.title = NSLocalizedString(@"My Bike", @"Title in nav & tab controller");
        self.navigationController.tabBarItem.title = self.title;
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tabbar_ic_borrow_active.png"] selectedImage:[[UIImage imageNamed:@"tabbar_ic_borrow_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _indicatorView.hidden = YES;
    _titleLabel.text = NSLocalizedString(@"Let's Go!", @"A label text somewhere on the screen");
    _codeLabel.text = NSLocalizedString(@"Bike lock code:", @"A label text somewhere on the screen");
    
    [_returnButton setTitleForAllState:NSLocalizedString(@"Return", @"A button title somewhere on the screen")];
    [_detailButton setTitleForAllState:NSLocalizedString(@"Bike Detail", @"A button title somewhere on the screen")];
    [_reportButton setTitleForAllState:NSLocalizedString(@"Report Issue", @"A button title somewhere on the screen")];
    
    _urlPath = [NSString stringWithFormat:@"%@/bikes/%@/status-webview",RekolaAPIURLString,[[ContentManager manager].usingBike.identifier stringValue]];
     _webView.requestSerializer = [APIManager manager].requestSerializer;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData {
    [self loadURL:[NSURL URLWithString:_urlPath]];
    
    NSMutableString *code = [ContentManager manager].usingBike.lockCode.mutableCopy;
    [code enumerateSubstringsInRange:NSMakeRange(0, code.length) options:NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationSubstringNotRequired usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
        if (substringRange.location > 0)
            [code insertString:@" " atIndex:substringRange.location];
    }];

    _codeField.text = code;
    NSString *bikeName = [ContentManager manager].usingBike.name? [NSString stringWithFormat:@" %@",[ContentManager manager].usingBike.name] : @"";
    _descriptionLabel.text = [NSString stringWithFormat:@"%@%@ %@",NSLocalizedString(@"Bike", @"A label text somewhere on the screen"), bikeName, NSLocalizedString(@"in your service.", @"A label text somewhere on the screen")];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LocateSegue"]) {
        _returnButton.enabled = NO;
        [(LocateViewController *)segue.destinationViewController setDelegate:self];
        
    } else if ([segue.identifier isEqualToString:@"ReturnBikeDetailSegue"]) {
        Bike *bike = [ContentManager manager].usingBike;
        NSString *urlPath = [NSString stringWithFormat:@"%@/bikes/%@/info-webview",RekolaAPIURLString,[bike.identifier stringValue]];
        BikeDetailViewController *controller = segue.destinationViewController;
        controller.urlPath = urlPath;
        controller.title = bike.name;
        
    } else if ([segue.identifier isEqualToString:@"IssueBikeDetailSegue"]) {
        Bike *bike = [ContentManager manager].usingBike;
        NSString *urlPath = [NSString stringWithFormat:@"%@/bikes/%@/issues-webview",RekolaAPIURLString,[bike.identifier stringValue]];
        BikeDetailViewController *controller = segue.destinationViewController;
        controller.urlPath = urlPath;
        controller.title = bike.name;
    }
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
                strongSelf.webIndicatorView.hidden = YES;
            }
        }
    }];
}

#pragma mark - UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.userInteractionEnabled = NO;
    _webIndicatorView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.userInteractionEnabled = YES;
    _webIndicatorView.hidden = YES;
}

#pragma mark - LocateViewControllerDelegate methods

- (void)controller:(LocateViewController *)controller didFinishWithLocation:(CLLocation *)location note:(NSString *)note {
    
    if (location) {
        _indicatorView.hidden = NO;
        [_indicatorView startAnimating];
        self.view.userInteractionEnabled = NO;
    } else {
        _returnButton.enabled = YES;
    }
    
    [controller dismissViewControllerAnimated:YES completion:^{
        if (location) {
            __weak __typeof(self)weakSelf = self;
            [[ContentManager manager] returnBike:[ContentManager manager].usingBike location:location note:note completion:^(NSString *successUrl, NSError *error) {
                if (weakSelf) {
                    if (!error) {
                        SuccessViewController *controller = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"SuccessViewController"];
                        controller.urlPath = successUrl;
                        [weakSelf.tabBarController presentViewController:controller animated:YES completion:^{
                            [ContentManager manager].usingBike = nil;
                            [ContentManager manager].bikesUpdateDate = nil;
                        }];
                        
                    } else {
                        [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                    }
                }
                
                weakSelf.view.userInteractionEnabled = YES;
                weakSelf.returnButton.enabled = YES;
                weakSelf.indicatorView.hidden = YES;
                [weakSelf.indicatorView stopAnimating];
            }];
        }
    }];
}

@end

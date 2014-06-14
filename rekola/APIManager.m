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

#import "APIManager.h"
#import "AFNetworkActivityIndicatorManager.h"

NSString *const AppStoreID = @"862678016";
NSString *const APIVersion = @"1.0.0";

#if defined(REKOLA_DEV)
NSString *const RekolaAPIURLString = @"http://vps.clevis.org/rekola-demo/www/api";
#else
NSString *const RekolaAPIURLString = @"https://moje.rekola.cz/api";
#endif

@implementation APIManager {
    struct {
        unsigned int handlingUpdate:1;
    } _flags;
}

+ (instancetype)manager {
	static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:RekolaAPIURLString]];
    });
    
	return _sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(networkingOperationDidFinish:) name:AFNetworkingOperationDidFinishNotification object:nil];
        
        // Custom networking serialized for request and response.
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];

        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Contet-Type"];
        
        // Prepare network activity indicator for the UIApplication.
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        [self updateUserAgent];
    }
    return self;
}

#pragma mark - Accessors

- (void)setAccessToken:(NSString *)accessToken {
    _accessToken = accessToken;
    [self.requestSerializer setValue:_accessToken forHTTPHeaderField:@"X-Api-Key"];
}

#pragma mark - Private methods

- (void)updateUserAgent {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    NSString *appName = @"Rekola";
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceFullName = [[UIDevice currentDevice] model];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *locale = [[[NSLocale currentLocale] objectForKey:NSLocaleIdentifier] stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ API %@ (%@; iOS %@; %.0f; %.0f; %@)", appName, appVersion, APIVersion, deviceFullName, systemVersion, size.width * scale, size.height * scale, locale];
    
#pragma clang diagnostic pop
    
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false);
            userAgent = mutableUserAgent;
        }
        [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent" : userAgent}];
    }
}

#pragma mark - Notifications

- (void)networkingOperationDidFinish:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = notification.object;
    
    if (operation.responseString) {
        if (operation.response.statusCode == HttpStatusCodeInternalServerError) {
            NSLog(@"Something went wrong on server!");
            
        } else if (operation.response.statusCode == HttpStatusCodeUnauthorize) {
            // the auth token is not valid, clear it
            NSLog(@"The auth token is not valid");
            if (_accessToken != nil) {
                [[ContentManager manager] logout];
            }
            
        } else if (!_flags.handlingUpdate && operation.response.statusCode == HttpStatusCodeForceUpdate) {
            
            _flags.handlingUpdate = 1;
            
            if (_accessToken != nil) {
                [[ContentManager manager] logout];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New version", @"Title in Alert View") message:NSLocalizedString(@"Sorry, but your application is outdated.\n\nPlese upgrade to latest version.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", @"Button title in Alert View.") otherButtonTitles:NSLocalizedString(@"Download", @"Button title in Alert View."), nil];
            
            [alert showWithCompletionBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
                _flags.handlingUpdate = 0;
                
                if (buttonIndex != alert.cancelButtonIndex) {
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms://itunes.apple.com/cz/app/id%@?mt=8", AppStoreID]];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
        }
        else if (operation.response.statusCode != HttpStatusCodeOk) {
            NSLog(@"Code: %li, Error: %@",(long)operation.response.statusCode, operation.responseString);
        }
    } else {
        NSLog(@"Server is unreachable - Could not resolve host %@",operation.request.URL);
    }
}

@end

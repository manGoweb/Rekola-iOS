//
//  APIManager.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworkActivityIndicatorManager.h"

NSString *const AppleID = @"missing";
NSString *const RekolaAPIURLString = @"missing";

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
        
        [self updateUserAgent];
        
        // Custom networking serialized for request and response.
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];

        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Contet-Type"];
        
        // Prepare network activity indicator for the UIApplication.
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    return self;
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
    
    NSString *userAgent = [NSString stringWithFormat:@"%@;%@;%@;iOS %@;%.0f;%.0f;%@;CZ)", appName, appVersion, deviceFullName, systemVersion, size.width * scale, size.height * scale, locale];
    
#pragma clang diagnostic pop
    
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false);
            userAgent = mutableUserAgent;
        }
        [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
}

#pragma mark - Notifications

- (void)networkingOperationDidFinish:(NSNotification *)notification {
    AFHTTPRequestOperation *operation = notification.object;
    
    if (operation.responseString) {
        if (operation.response.statusCode == HttpStatusCodeInternalServerError) {
            NSLog(@"Something went wrong on server!");
            
        } else if (operation.response.statusCode == HttpStatusCodeUnauthorize) {
            // the auth token is no longer valid, clear it
            NSLog(@"The auth token is no longer valid");
            
        } else if (!_flags.handlingUpdate && operation.response.statusCode == HttpStatusCodeForceUpdate) {
            
            _flags.handlingUpdate = 1;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New version", @"Title in Alert View") message:NSLocalizedString(@"Sorry, but your client is outdated.\n\nPlese upgrade to latest version.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", @"Button title in Alert View.") otherButtonTitles:NSLocalizedString(@"Download", @"Button title in Alert View."), nil];
            
            [alert showWithCompletionBlock:^(UIAlertView *alert, NSInteger buttonIndex) {
                _flags.handlingUpdate = 0;
                
                // TODO: missing app apple id
                if (buttonIndex != alert.cancelButtonIndex) {
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms://itunes.apple.com/cz/app/id%@?mt=8", ApplicationAppStoreAppleID]];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
        }
        else if (operation.response.statusCode != HttpStatusCodeOk && operation.response.statusCode != HttpStatusCodeNoContent && operation.response.statusCode != HttpStatusCodeCreated) {
            NSLog(@"Code: %i, Error: %@",operation.response.statusCode, operation.responseString);
        }
    } else {
        NSLog(@"Server is unreachable - Could not resolve host %@",operation.request.URL);
    }
}

@end

//
//  APIManager.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef NS_ENUM(NSInteger, HttpStatusCode) {
    /// the request was successful
    HttpStatusCodeOk =                      200,
    /// the request was successful and a resource was created
    HttpStatusCodeCreated =                 201,
    /// the request could not be understold or was missing required parameters
    HttpStatusCodeNoContent =               204,
    /// authenication failed or the user doesn't have permissions for the requested operation
    HttpStatusCodeBadRequest =              400,
    /// authenication failed or the user doesn't have permissions for the requested operation
    HttpStatusCodeUnauthorize =             401,
    /// access to the requested resource denied
    HttpStatusCodeForbidden =               403,
    /// the requested resource could not be found
    HttpStatusCodeNotFound =                404,
    /// the request could not be actioned as it would result in a conflict with another resource
    HttpStatusCodeConflict =                409,
    /// There was an uncaught exception in the api
    HttpStatusCodeInternalServerError =     500,
    /// Force update application
    HttpStatusCodeForceUpdate =             999
};

@interface APIManager : AFHTTPRequestOperationManager

@property (nonatomic, copy) NSString *accessToken;

@end

extern NSString *const AppStoreID;
extern NSString *const RekolaAPIURLString;
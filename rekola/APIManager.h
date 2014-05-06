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
    HttpStatusCodeForceUpdate =             426
};

@interface APIManager : AFHTTPRequestOperationManager

@property (nonatomic, copy) NSString *accessToken;

@end

extern NSString *const AppStoreID;
extern NSString *const RekolaAPIURLString;
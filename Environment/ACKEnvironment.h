//
//  ACKEnvironment.h
//  ProjectName
//
//  Created by Dominik Vesely on 20/06/14.
//  Copyright (c) 2014 Ackee s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACKEnvironment : NSObject

// Tady muze byt URL na Backend nebo Klic do API sluzby atd atd!!!
@property (nonatomic,strong) NSString* appName;
@property (nonatomic,strong) NSString* baseURL;


/**
 * Singleton instance for accessing environment-specific values
 */
+(instancetype)sharedEnvironment;


@end

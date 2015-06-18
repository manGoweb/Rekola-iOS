//
//  ACKEnvironment.m
//  ProjectName
//
//  Created by Dominik Vesely on 20/06/14.
//  Copyright (c) 2014 Ackee s.r.o. All rights reserved.
//

#import "ACKEnvironment.h"

@implementation ACKEnvironment

+ (instancetype)sharedEnvironment {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[ACKEnvironment alloc] init];
    });
}

-(instancetype)init {
	self = [super init];
	if (self != nil) {
		NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"environment" ofType:@"plist"]];
		_appName = plist[@"appName"];
        _baseURL = plist[@"baseURL"];
	}
	return self;
}

@end

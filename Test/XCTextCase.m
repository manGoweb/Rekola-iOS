//
//  XCTextCase.m
//  ProjectName
//
//  Created by Dominik Vesely on 18/06/14.
//  Copyright (c) 2014 Ackee s.r.o. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTextCase : XCTestCase

@end

@implementation XCTextCase

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTAssertEqual(true, true, @"");
}

@end

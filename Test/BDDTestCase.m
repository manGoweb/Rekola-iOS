//
//  ProjectNameTests.m
//  ProjectNameTests
//
//  Created by Dominik Vesely on 18/06/14.
//  Copyright (c) 2014 Ackee s.r.o. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(MathSpec)

context(@"MyContext", ^{
    describe(@"Math", ^{
        it(@"is pretty cool", ^{
            NSUInteger a = 16;
            NSUInteger b = 26;
            [[theValue(a + b) should] equal:theValue(42)];
        });
    });
});


SPEC_END

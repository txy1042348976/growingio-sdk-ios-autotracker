//
//  GDPRTest.m
//  GIOAutoTests
//
//  Created by GrowingIO on 2018/6/19.
//  Copyright (C) 2018 Beijing Yishu Technology Co., Ltd.
//
#import <KIF/KIF.h>
#import <XCTest/XCTest.h>

#import "GrowingAutotracker.h"
#import "GrowingTracker.h"
#import "MockEventQueue.h"

@interface GDPRTest : KIFTestCase

@end

@implementation GDPRTest

- (void)beforeEach {
    [[GrowingAutotracker sharedInstance] setDataCollectionEnabled:NO];
    [MockEventQueue.sharedQueue cleanQueue];
}

- (void)test1DisableDataCollect {
    [[viewTester usingLabel:@"UI界面"] tap];
    [tester waitForTimeInterval:1];
    NSArray *clickEventArray = [MockEventQueue.sharedQueue rawEventsFor:@"VIEW_CLICK"];
    XCTAssertEqual(clickEventArray.count, 0);
}

- (void)test2EnableDataCollect {
    [[viewTester usingLabel:@"UI界面"] tap];
    [tester waitForTimeInterval:1];
    NSArray *clickEventArray = [MockEventQueue.sharedQueue rawEventsFor:@"VIEW_CLICK"];
    XCTAssertEqual(clickEventArray.count, 0);

    [[GrowingAutotracker sharedInstance] setDataCollectionEnabled:YES];

    [[viewTester usingLabel:@"协议/接口"] tap];
    [[viewTester usingLabel:@"CLICK请求"] tap];
    [[viewTester usingLabel:@"send click event"] tap];

    clickEventArray = [MockEventQueue.sharedQueue rawEventsFor:@"VIEW_CLICK"];
    XCTAssertGreaterThanOrEqual(clickEventArray.count, 1);
}

@end

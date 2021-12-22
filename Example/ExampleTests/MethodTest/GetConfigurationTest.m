//
//  GetConfigurationTest.m
//  GIOAutoTests
//
//  Created by GrowingIO on 7/24/20.
//  Copyright © 2020 GrowingIO. All rights reserved.
//

#import <KIF/KIF.h>
#import <XCTest/XCTest.h>

#import "GrowingAutotracker.h"
#import "GrowingSession.h"
#import "MockEventQueue.h"

@interface GetConfigurationTest : KIFTestCase

@end

@implementation GetConfigurationTest

- (void)test1GetConfigurationTest {
    [MockEventQueue.sharedQueue cleanQueue];

    GrowingTrackConfiguration *configuration = [GrowingTrackConfiguration configurationWithProjectId:@"aaaa"];
    [GrowingAutotracker startWithConfiguration:configuration launchOptions:nil];

    XCTAssertEqual(configuration.debugEnabled, NO);
    XCTAssertEqual(configuration.dataUploadInterval, 15);
    XCTAssertEqual(configuration.sessionInterval, 30);
    XCTAssertEqual(configuration.cellularDataLimit, 10);
    XCTAssertEqual(configuration.uploadExceptionEnable, YES);
    NSLog(@"测试配置通过---passed");
}

- (void)testGetDeviceId {
    XCTAssertNotNil([[GrowingAutotracker sharedInstance] getDeviceId]);
}

- (void)testGetSessionId {
    XCTAssertNotNil([[GrowingSession currentSession] sessionId]);
}

@end

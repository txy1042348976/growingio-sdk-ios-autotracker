//
//  FlushIntervalAPITest.m
//  GIOAutoTests
//
//  Created by GrowingIO on 2018/6/19.
//  Copyright (C) 2018 Beijing Yishu Technology Co., Ltd.
//
#import <KIF/KIF.h>
#import <XCTest/XCTest.h>

#import "GrowingAutotracker.h"
#import "GrowingEventManager.h"
#import "GrowingTracker.h"
#import "MockEventQueue.h"

@interface FlushIntervalAPITest : KIFTestCase <GrowingEventInterceptor>

@end

@implementation FlushIntervalAPITest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - GrowingEventInterceptor

- (void)test1GetFlushInterVal {
    GrowingAutotrackConfiguration *configuration =
        [GrowingAutotrackConfiguration configurationWithProjectId:@"testProjectId"];
    NSLog(@"流量上传间隔 %lu", (unsigned long)configuration.dataUploadInterval);
    XCTAssertEqual((unsigned long)configuration.dataUploadInterval, 15);
    [GrowingAutotracker startWithConfiguration:configuration launchOptions:nil];
}

@end

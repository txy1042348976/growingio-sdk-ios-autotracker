//
//  TrackViewTest.m
//  GIOAutoTests
//
//  Created by GrowingIO on 2018/8/22.
//  Copyright (C) 2018 Beijing Yishu Technology Co., Ltd.
//
#import <KIF/KIF.h>

#import "GrowingAutotracker.h"
#import "GrowingDispatchManager.h"
#import "GrowingEventManager.h"
#import "MockEventQueue.h"

@interface DataCollectionSwitchTest : KIFTestCase <GrowingEventInterceptor>

@property (nonatomic, assign) BOOL isSend;

@end

@implementation DataCollectionSwitchTest

- (void)beforeEach {
    [[GrowingEventManager sharedInstance] addInterceptor:self];
}

- (void)afterEach {
    [[GrowingEventManager sharedInstance] removeInterceptor:self];
}

- (void)growingEventManagerEventDidBuild:(GrowingBaseEvent *)event {
    _isSend = YES;
}

- (void)test1TackviewFalse {
    [[GrowingAutotracker sharedInstance] setDataCollectionEnabled:NO];
    _isSend = NO;
    [[GrowingAutotracker sharedInstance] trackCustomEvent:@"DataCollectionSwitchTest"];
    TestRun(XCTAssertTrue(!self->_isSend, "can`t send Event while dataCollection is set NO"));
}

@end

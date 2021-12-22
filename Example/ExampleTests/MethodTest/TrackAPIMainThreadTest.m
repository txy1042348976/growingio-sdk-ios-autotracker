//
//  TrackAPIMainThreadTest.m
//  GIOAutoTests
//
//  Created by GrowingIO on 2019/11/8.
//  Copyright © 2019 GrowingIO. All rights reserved.
//

#import <KIF/KIF.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <objc/runtime.h>

#import "GrowingAutotracker.h"
#import "GrowingDispatchManager.h"
#import "GrowingEventManager.h"
#import "GrowingSession.h"
#import "GrowingThread.h"
#import "GrowingTracker.h"
#import "MockEventQueue.h"

@interface TrackAPIMainThreadTest : KIFTestCase <GrowingEventInterceptor>

@end

@implementation TrackAPIMainThreadTest

+ (void)setUp {
    [super setUp];
}

+ (void)tearDown {
    [super tearDown];
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    [[GrowingEventManager sharedInstance] addInterceptor:self];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [[GrowingEventManager sharedInstance] removeInterceptor:self];
    [super tearDown];
}

#pragma mark - GrowingEventInterceptor

- (void)growingEventManagerEventDidBuild:(GrowingBaseEvent *)event {
    XCTAssertTrue([NSThread currentThread] == [GrowingThread sharedThread]);
}

#pragma mark -GrowingCoreKit API Test

- (void)test1SetUserIdTest {
    [[GrowingAutotracker sharedInstance] cleanLoginUserId];
    NSString *userId = @"123456789";
    [[GrowingAutotracker sharedInstance] setLoginUserId:userId];
    TestRun(XCTAssertEqual([GrowingSession currentSession].loginUserId, userId);)
}

- (void)test2ClearUserIdTest {
    [[GrowingAutotracker sharedInstance] cleanLoginUserId];
    TestRun(XCTAssertEqual([GrowingSession currentSession].loginUserId, nil);)
}

- (void)test3SetConversionVariablesTest {
    [[GrowingAutotracker sharedInstance] setConversionVariables:@{@"EvarAutoTest" : @"evarAuto"}];
}

- (void)test4SetEvarAndStringTest {
    [[GrowingAutotracker sharedInstance] setConversionVariables:@{@"EvarKeyAutoTest" : @"evarKeyAutoString"}];
}

- (void)test5SetEvarAndNumberTest {
    [[GrowingAutotracker sharedInstance] setConversionVariables:@{@"EvarNumberAutoTest" : @22}];
}

- (void)test6SetPeopleTest {
    [[GrowingAutotracker sharedInstance] setLoginUserAttributes:@{@"PeopleAutoTest" : @"peopleAuto"}];
}

- (void)test7SetPeopleAndStringTest {
    [[GrowingAutotracker sharedInstance] setLoginUserAttributes:@{@"PeopleKeyAutoTest" : @"PeopleKeyAutoString"}];
}

- (void)test8SetPeopleAndNumberTest {
    [[GrowingAutotracker sharedInstance] setLoginUserAttributes:@{@"PeopleNumberAutoTest" : @22}];
}

- (void)test9TrackTest {
    [[GrowingAutotracker sharedInstance] trackCustomEvent:@"TrackAutoTest"];
}

- (void)test10TrackAndNumberTest {
    [[GrowingAutotracker sharedInstance] trackCustomEvent:@"TrackAutoTest"];
    [[GrowingAutotracker sharedInstance] trackCustomEvent:@"TrackAutoTest"];
}

- (void)test11TrackAndNumberAndVariableTest {
    [[GrowingAutotracker sharedInstance] trackCustomEvent:@"TrackAutoTest"
                                           withAttributes:@{@"TrackAutoTest" : @"trackAutoTest"}];
}

- (void)test11TrackAndVariableTest {
    [[GrowingAutotracker sharedInstance] trackCustomEvent:@"TrackAutoTest"
                                           withAttributes:@{@"TrackAutoTest" : @"trackAutoTest"}];
}

- (void)test12SetVisitorTest {
    [[GrowingAutotracker sharedInstance] setVisitorAttributes:@{@"VisitorAutoTest" : @"visitorAutoTest"}];
}

#pragma mark - GrowingAutoTracker API Test
- (void)test13PageVariableToViewControllerTest {
    UIViewController *vc = [UIViewController new];
    vc.growingPageAttributes = @{@"PageVariable" : @"pageVariable"};
}

- (void)test14SetUserIdAndUserKeyTest {
    [[GrowingAutotracker sharedInstance] cleanLoginUserId];
    NSString *userId = @"123456789";
    [[GrowingAutotracker sharedInstance] setLoginUserId:userId userKey:@"number"];
    TestRun(XCTAssertEqual([GrowingSession currentSession].loginUserId, userId);
            XCTAssertEqual([GrowingSession currentSession].loginUserKey, @"number"););

    [[GrowingAutotracker sharedInstance] setLoginUserId:@"223344"];
    TestRun2(XCTAssertEqual([GrowingSession currentSession].loginUserKey, nil););
}

@end

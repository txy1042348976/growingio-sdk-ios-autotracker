//
//  VisitEventsTest.m
//  GIOAutoTests
//
//  Created by GrowingIO on 2018/2/22.
//  Copyright (C) 2018 Beijing Yishu Technology Co., Ltd.
//

#import "A3VisitEventsTest.h"

#import "GrowingTestHelper.h"
#import "GrowingAutotracker.h"
#import "MockEventQueue.h"
#import "NoburPoMeaProCheck.h"
#import "GrowingAutotrackEventType.h"

@implementation A3VisitEventsTest

- (void)beforeEach {
    //设置userid,确保cs1字段不空
    [[GrowingAutotracker sharedInstance] setLoginUserId:@"test"];
    [[viewTester usingLabel:@"UI界面"] tap];

}
- (void)afterEach {
    //[GrowingTestHelper ExiteApp];
}

- (void)test1SetLocation {
    /**
     function:SetLocation触发，从null -> 非null 发一次。非null - 非null不发visit
     **/
//    NSString *oldSession = [[GrowingAutotracker sharedInstance] getSessionId];
//    XCTAssertNotNil(oldSession);
    [[GrowingAutotracker sharedInstance] cleanLocation];
    [MockEventQueue.sharedQueue cleanQueue];
    [[GrowingAutotracker sharedInstance] setLocation:[@30.11 doubleValue] longitude:[@32.22 doubleValue]];
    NSArray *visitEventArray = [MockEventQueue.sharedQueue eventsFor:GrowingEventTypeVisit];
    if (visitEventArray.count > 0) {
        NSDictionary *visit_chr = [visitEventArray objectAtIndex:visitEventArray.count - 1];
        NSLog(@"Check Result:%@", visit_chr);
        XCTAssertEqualObjects(visit_chr[@"latitude"], @30.11);
        XCTAssertEqualObjects(visit_chr[@"longitude"], @32.22);
        TestLog(@"setLocation 从null -> 非null 发visit，测试通过--Passed！");
    } else {
        TestLog(@"setLocation 从null -> 非null 发visit，测试不通过:%@", visitEventArray);
        XCTAssertEqual(1, 0);
    }
}

@end

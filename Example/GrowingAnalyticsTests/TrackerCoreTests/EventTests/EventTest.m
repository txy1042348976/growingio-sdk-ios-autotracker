//
//  EventTest.m
//  GrowingAnalytics
//
//  Created by YoloMao on 2021/12/31.
//  Copyright (C) 2021 Beijing Yishu Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


#import <XCTest/XCTest.h>

#import "GrowingConfigurationManager.h"
#import "GrowingSession.h"
#import "GrowingDeviceInfo.h"
#import "GrowingServiceManager.h"
#import "GrowingEventDatabaseService.h"
#import "GrowingEventFMDatabase.h"
#import "GrowingEventManager.h"
#import "MockEventQueue.h"
#import "ManualTrackHelper.h"
#import "GrowingAutotrackEventType.h"
#import "GrowingVisitEvent.h"
#import "GrowingCustomEvent.h"
#import "GrowingAppCloseEvent.h"
#import "GrowingPageEvent.h"
#import "GrowingVisitorAttributesEvent.h"
#import "GrowingConversionVariableEvent.h"
#import "GrowingLoginUserAttributesEvent.h"
#import "GrowingPageAttributesEvent.h"

@implementation GrowingDeviceInfo (XCTest)

- (NSString *)getCurrentUrlScheme {
    return @"growing.xctest";
}

@end

@interface EventTest : XCTestCase

@end

@implementation EventTest

+ (void)setUp {
    GrowingTrackConfiguration *config = [GrowingTrackConfiguration configurationWithProjectId:@"test"];
    // 避免不执行readPropertyInTrackThread
    config.dataCollectionEnabled = YES;
    // 开启idMapping
    config.idMappingEnabled = YES;
    GrowingConfigurationManager.sharedInstance.trackConfiguration = config;
    
    // 避免insertEventToDatabase异常
    [GrowingServiceManager.sharedInstance registerService:@protocol(GrowingEventDatabaseService)
                                                implClass:GrowingEventFMDatabase.class];
    // 初始化sessionId
    [GrowingSession startSession];
    // userId userKey
    [GrowingSession.currentSession setLoginUserId:@"xctest_userId" userKey:@"xctest_userKey"];
    // latitude longitude
    [GrowingSession.currentSession setLocation:30.123456 longitude:31.123456];
}

- (void)setUp {
    [MockEventQueue.sharedQueue cleanQueue];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testGrowingVisitEvent {
    GrowingVisitEvent.builder.setIdfa(@"testIdfa")
        .setIdfv(@"testIdfv")
        .setExtraSdk(@{@"testkey" : @"value"})
        .setNetworkState(@"testNetworkState")
        .setScreenHeight(1920)
        .setScreenWidth(1280)
        .setDeviceBrand(@"testDeviceBrand")
        .setDeviceModel(@"testDeviceModel")
        .setDeviceType(@"testDeviceType")
        .setAppName(@"testAppName")
        .setAppVersion(@"testAppVersion")
        .setLanguage(@"testLanguage")
        .setSdkVersion(@"testSdkVersion")
        .setDomain(@"testdomain")
        .setLanguage(@"testlanguage")
        .setLatitude(10)
        .setLongitude(11)
        .setPlatform(@"iOS")
        .setTimestamp(12345678)
        .setUserId(@"zhangsan")
        .setUserKey(@"phone")
        .setDeviceId(@"testdeviceID");
    
    GrowingBaseBuilder *builder = GrowingVisitEvent.builder;
    [GrowingEventManager.sharedInstance postEventBuidler:builder];

    NSArray<GrowingBaseEvent *> *events = [MockEventQueue.sharedQueue eventsFor:GrowingEventTypeVisit];
    XCTAssertEqual(events.count, 1);
    
    GrowingVisitEvent *event = (GrowingVisitEvent *)events.firstObject;
    XCTAssertEqualObjects(event.eventType, GrowingEventTypeVisit);
    
    NSDictionary *dic = event.toDictionary;
    XCTAssertEqualObjects(dic[@"eventType"], GrowingEventTypeVisit);
    XCTAssertTrue([ManualTrackHelper visitEventCheck:dic]);
    XCTAssertTrue([self contextOptionalPropertyCheck:dic]);
}

- (void)testGrowingCustomEvent {
    GrowingBaseBuilder *builder = GrowingCustomEvent.builder.setEventName(@"custom").setAttributes(@{@"key" : @"value"});
    [GrowingEventManager.sharedInstance postEventBuidler:builder];

    NSArray<GrowingBaseEvent *> *events = [MockEventQueue.sharedQueue eventsFor:GrowingEventTypeCustom];
    XCTAssertEqual(events.count, 1);
    
    GrowingCustomEvent *event = (GrowingCustomEvent *)events.firstObject;
    XCTAssertEqualObjects(event.eventType, GrowingEventTypeCustom);
    XCTAssertEqualObjects(event.eventName, @"custom");
    XCTAssertEqualObjects(event.attributes[@"key"], @"value");
    
    NSDictionary *dic = event.toDictionary;
    XCTAssertEqualObjects(dic[@"eventType"], GrowingEventTypeCustom);
    XCTAssertEqualObjects(dic[@"eventName"], @"custom");
    XCTAssertEqualObjects(dic[@"attributes"][@"key"], @"value");
    XCTAssertTrue([ManualTrackHelper customEventCheck:dic]);
    XCTAssertTrue([self contextOptionalPropertyCheck:dic]);
}

- (void)testGrowingLoginUserAttributesEvent {
    GrowingBaseBuilder *builder = GrowingLoginUserAttributesEvent.builder.setAttributes(@{@"key" : @"value"});
    [GrowingEventManager.sharedInstance postEventBuidler:builder];

    NSArray<GrowingBaseEvent *> *events = [MockEventQueue.sharedQueue eventsFor:GrowingEventTypeLoginUserAttributes];
    XCTAssertEqual(events.count, 1);
    
    GrowingLoginUserAttributesEvent *event = (GrowingLoginUserAttributesEvent *)events.firstObject;
    XCTAssertEqualObjects(event.eventType, GrowingEventTypeLoginUserAttributes);
    XCTAssertEqualObjects(event.attributes[@"key"], @"value");
    
    NSDictionary *dic = event.toDictionary;
    XCTAssertEqualObjects(dic[@"eventType"], GrowingEventTypeLoginUserAttributes);
    XCTAssertEqualObjects(dic[@"attributes"][@"key"], @"value");
    XCTAssertTrue([ManualTrackHelper loginUserAttributesEventCheck:dic]);
    XCTAssertTrue([self contextOptionalPropertyCheck:dic]);
}

- (void)testGrowingConversionVariableEvent {
    GrowingBaseBuilder *builder = GrowingConversionVariableEvent.builder.setAttributes(@{@"key" : @"value"});
    [GrowingEventManager.sharedInstance postEventBuidler:builder];

    NSArray<GrowingBaseEvent *> *events = [MockEventQueue.sharedQueue eventsFor:GrowingEventTypeConversionVariables];
    XCTAssertEqual(events.count, 1);
    
    GrowingConversionVariableEvent *event = (GrowingConversionVariableEvent *)events.firstObject;
    XCTAssertEqualObjects(event.eventType, GrowingEventTypeConversionVariables);
    XCTAssertEqualObjects(event.attributes[@"key"], @"value");
    
    NSDictionary *dic = event.toDictionary;
    XCTAssertEqualObjects(dic[@"eventType"], GrowingEventTypeConversionVariables);
    XCTAssertEqualObjects(dic[@"attributes"][@"key"], @"value");
    XCTAssertTrue([ManualTrackHelper conversionVariablesEventCheck:dic]);
    XCTAssertTrue([self contextOptionalPropertyCheck:dic]);
}

- (void)testGrowingVisitorAttributesEvent {
    GrowingBaseBuilder *builder = GrowingVisitorAttributesEvent.builder.setAttributes(@{@"key" : @"value"});
    [GrowingEventManager.sharedInstance postEventBuidler:builder];

    NSArray<GrowingBaseEvent *> *events = [MockEventQueue.sharedQueue eventsFor:GrowingEventTypeVisitorAttributes];
    XCTAssertEqual(events.count, 1);
    
    GrowingVisitorAttributesEvent *event = (GrowingVisitorAttributesEvent *)events.firstObject;
    XCTAssertEqualObjects(event.eventType, GrowingEventTypeVisitorAttributes);
    XCTAssertEqualObjects(event.attributes[@"key"], @"value");
    
    NSDictionary *dic = event.toDictionary;
    XCTAssertEqualObjects(dic[@"eventType"], GrowingEventTypeVisitorAttributes);
    XCTAssertEqualObjects(dic[@"attributes"][@"key"], @"value");
    XCTAssertTrue([ManualTrackHelper visitorAttributesEventCheck:dic]);
    XCTAssertTrue([self contextOptionalPropertyCheck:dic]);
}

- (void)testGrowingAppCloseEvent {
    GrowingBaseBuilder *builder = GrowingAppCloseEvent.builder;
    [GrowingEventManager.sharedInstance postEventBuidler:builder];

    NSArray<GrowingBaseEvent *> *events = [MockEventQueue.sharedQueue eventsFor:GrowingEventTypeAppClosed];
    XCTAssertEqual(events.count, 1);
    
    GrowingAppCloseEvent *event = (GrowingAppCloseEvent *)events.firstObject;
    XCTAssertEqualObjects(event.eventType, GrowingEventTypeAppClosed);
    
    NSDictionary *dic = event.toDictionary;
    XCTAssertEqualObjects(dic[@"eventType"], GrowingEventTypeAppClosed);
    XCTAssertTrue([ManualTrackHelper appCloseEventCheck:dic]);
    XCTAssertTrue([self contextOptionalPropertyCheck:dic]);
}

//- (void)testGrowingPageEvent {
//    GrowingBaseBuilder *builder = GrowingPageEvent.builder
//        .setPath(@"path")
//        .setOrientation(@"orientation")
//        .setTitle(@"title")
//        .setReferralPage(@"referralPage");
//    [GrowingEventManager.sharedInstance postEventBuidler:builder];
//
//    NSArray<GrowingBaseEvent *> *events = [MockEventQueue.sharedQueue eventsFor:GrowingEventTypePage];
//    XCTAssertEqual(events.count, 1);
//
//    GrowingPageEvent *event = (GrowingPageEvent *)events.firstObject;
//    XCTAssertEqualObjects(event.eventType, GrowingEventTypePage);
//    XCTAssertEqualObjects(event.pageName, @"path");
//    XCTAssertEqualObjects(event.orientation, @"orientation");
//    XCTAssertEqualObjects(event.title, @"title");
//    XCTAssertEqualObjects(event.referralPage, @"referralPage");
//
//    NSDictionary *dic = event.toDictionary;
//    XCTAssertEqualObjects(dic[@"eventType"], GrowingEventTypePage);
//    XCTAssertEqualObjects(dic[@"path"], @"path");
//    XCTAssertEqualObjects(dic[@"orientation"], @"orientation");
//    XCTAssertEqualObjects(dic[@"title"], @"title");
//    XCTAssertEqualObjects(dic[@"referralPage"], @"referralPage");
//    XCTAssertTrue([ManualTrackHelper pageEventCheck:dic]);
//    XCTAssertTrue([self contextOptionalPropertyCheck:dic]);
//}

- (void)testGrowingPageAttributesEvent {
    GrowingBaseBuilder *builder = GrowingPageAttributesEvent.builder
        .setPath(@"path")
        .setPageShowTimestamp(1638857558209)
        .setAttributes(@{@"key" : @"value"});
    [GrowingEventManager.sharedInstance postEventBuidler:builder];

    NSArray<GrowingBaseEvent *> *events = [MockEventQueue.sharedQueue eventsFor:GrowingEventTypePageAttributes];
    XCTAssertEqual(events.count, 1);
    
    GrowingPageAttributesEvent *event = (GrowingPageAttributesEvent *)events.firstObject;
    XCTAssertEqualObjects(event.eventType, GrowingEventTypePageAttributes);
    XCTAssertEqualObjects(event.path, @"path");
    XCTAssertEqual(event.pageShowTimestamp, 1638857558209);
    XCTAssertEqualObjects(event.attributes[@"key"], @"value");
    
    NSDictionary *dic = event.toDictionary;
    XCTAssertEqualObjects(dic[@"eventType"], GrowingEventTypePageAttributes);
    XCTAssertEqualObjects(dic[@"path"], @"path");
    XCTAssertEqualObjects(dic[@"pageShowTimestamp"], @(1638857558209));
    XCTAssertEqualObjects(dic[@"attributes"][@"key"], @"value");
    XCTAssertTrue([ManualTrackHelper pageAttributesEventCheck:dic]);
    XCTAssertTrue([self contextOptionalPropertyCheck:dic]);
}

- (BOOL)contextOptionalPropertyCheck:(NSDictionary *)event {
    if (event.count == 0) {
        return NO;
    }
    for (NSString *optionalKey in ManualTrackHelper.contextOptional) {
        BOOL find = NO;
        for (NSString *key in event.allKeys) {
            if ([optionalKey isEqualToString:key]) {
                find = YES;
                break;
            }
        }
        if (!find) {
            return NO;
        }
    }
    
    return YES;
}

@end

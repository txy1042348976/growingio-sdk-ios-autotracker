//
//  ExampleUITests.m
//  GrowingAnalytics
//
//  Created by sheng on 2021/12/22.
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

@interface ExampleUITests : XCTestCase

@end

@implementation ExampleUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExampleSetUserId {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    [app.tables[@"MeasurementProtocolTableView"].staticTexts[@"+ (void)setUserId:(NSString *)userId;"] tap];
    
    XCUIApplication *app2 = app;
    [app2/*@START_MENU_TOKEN@*/.staticTexts[@"SetUserId"]/*[[".buttons[@\"SetUserId\"].staticTexts[@\"SetUserId\"]",".staticTexts[@\"SetUserId\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app.textFields[@"请自定一个设置userId"] tap];
    XCUIElement *textField = app.textFields[@"请自定一个设置userId"];
    [UIPasteboard generalPasteboard].string = @"MyText";
    [textField doubleTap];
    [[[app menuItems] elementBoundByIndex:0] tap];
    [app2/*@START_MENU_TOKEN@*/.staticTexts[@"CustomSet"]/*[[".buttons[@\"CustomSet\"].staticTexts[@\"CustomSet\"]",".staticTexts[@\"CustomSet\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app2/*@START_MENU_TOKEN@*/.staticTexts[@"ChangeUserId"]/*[[".buttons[@\"ChangeUserId\"].staticTexts[@\"ChangeUserId\"]",".staticTexts[@\"ChangeUserId\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app2/*@START_MENU_TOKEN@*/.staticTexts[@"CleanUserId"]/*[[".buttons[@\"CleanUserId\"].staticTexts[@\"CleanUserId\"]",".staticTexts[@\"CleanUserId\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app2/*@START_MENU_TOKEN@*/.staticTexts[@"setUserKey1"]/*[[".buttons[@\"setUserKey1\"].staticTexts[@\"setUserKey1\"]",".staticTexts[@\"setUserKey1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];

    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//- (void)testExamplePage {
//    XCUIApplication *app = [[XCUIApplication alloc] init];
//    [app launch];
//    [app.tables[@"MeasurementProtocolTableView"].staticTexts[@"PAGE请求"] tap];
//    [app/*@START_MENU_TOKEN@*/.staticTexts[@"\U8fdb\U5165\U6d4b\U8bd5"]/*[[".buttons[@\"\\U8fdb\\U5165\\U6d4b\\U8bd5\"].staticTexts[@\"\\U8fdb\\U5165\\U6d4b\\U8bd5\"]",".staticTexts[@\"\\U8fdb\\U5165\\U6d4b\\U8bd5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
//    [app.navigationBars[@"GIOContainerView"].buttons[@"page \U8bf7\U6c42"] tap];
//    [app.navigationBars[@"page \U8bf7\U6c42"].buttons[@"\U534f\U8bae/\U63a5\U53e3 \U6d4b\U8bd5"] tap];
//    [app.tables[@"MeasurementProtocolTableView"]/*@START_MENU_TOKEN@*/.staticTexts[@"VISIT\U8bf7\U6c42"]/*[[".cells.staticTexts[@\"VISIT\\U8bf7\\U6c42\"]",".staticTexts[@\"VISIT\\U8bf7\\U6c42\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
//    [[app childrenMatchingType:XCUIElementTypeWindow].element tap];
//    [app.alerts[@"Allow \U201cExample\U201d to use your location?"].scrollViews.otherElements.buttons[@"Allow While Using App"] tap];
        
//}

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)) {
        // This measures how long it takes to launch your application.
        [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

@end

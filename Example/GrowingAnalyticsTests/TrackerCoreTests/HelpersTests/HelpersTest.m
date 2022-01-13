//
//  HelpersTest.m
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

#import "NSData+GrowingHelper.h"
#import "NSString+GrowingHelper.h"
#import "UIImage+GrowingHelper.h"
#import "UIWindow+GrowingHelper.h"

@interface HelpersTest : XCTestCase

@end

@implementation HelpersTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNSDataGrowingHelper {
    NSString *testString = @"123测试";
    NSData *testData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertNotNil([testData growingHelper_LZ4String]);
    XCTAssertNil([testData growingHelper_dictionaryObject]);
    XCTAssertNil([testData growingHelper_arrayObject]);
    XCTAssertNotNil([testData growingHelper_md5String]);
    XCTAssertNotNil([testData growingHelper_xorEncryptWithHint:0x1F]);
}

- (void)testNSStringGrowingHelper {
    NSString *testString1 = @"12测试";
    XCTAssertNil([testString1 growingHelper_queryObject]);
    NSString *a = @"\\";
    [a growingHelper_uft8Data];
    [a growingHelper_jsonObject];
    [a growingHelper_dictionaryObject];
    [a growingHelper_safeSubStringWithLength:1];
    [a growingHelper_sha1];
    [a growingHelper_isLegal];
    [a growingHelper_isValidU];
    [a growingHelper_encryptString];
    XCTAssertFalse([NSString growingHelper_isBlankString:@"t"]);
    [a convertToDictFromPasteboard];
    XCTAssertFalse([NSString growingHelper_isEqualStringA:@"A" andStringB:@"B"]);
}

- (void)testImageHelper {
    UIImage *image = [[UIImage alloc] init];
    NSData *data = [image growingHelper_JPEG:0.8];
    [image growingHelper_PNG];
    [image growingHelper_Base64PNG];
    [image growingHelper_Base64JPEG:0.9];
    [image growingHelper_getSubImage:CGRectMake(0.8, 0.8, 0.8, 0.8)];
}

- (void)testUIWindowHelper {
    [UIWindow growingHelper_screenshotWithWindows:nil andMaxScale:0.8];
    [UIWindow growingHelper_screenshotWithWindows:nil andMaxScale:0.8 block:nil];
}

@end

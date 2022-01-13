//
//  ManualTrackHelper.m
//  GIOAutoTests
//
//  Created by GrowingIO on 2018/6/6.
//  Copyright (C) 2018 Beijing Yishu Technology Co., Ltd.
//  function:打点事件测试公共方法

#import "ManualTrackHelper.h"

#import "NoburPoMeaProCheck.h"

@implementation ManualTrackHelper

#pragma mark - Public Methods

//判断字典dicts是否包含关键字ckchar
+ (Boolean *)CheckContainsKey:(NSDictionary *)dicts:(NSString *)ckchar {
    NSArray *allkeys = dicts.allKeys;
    for (int i = 0; i < allkeys.count; i++) {
        if ([allkeys[i] isEqualToString:ckchar]) {
            return TRUE;
        }
    }
    return FALSE;
}

+ (BOOL)visitEventCheck:(NSDictionary *)event {
    if (event.count == 0) {
        return NO;
    }
    NSArray *protocol = self.context;
    NSArray *optional = @[@"idfa", @"idfv", @"extraSdk"];
    return [self protocolCheck:event protocol:protocol] && [self emptyPropertyCheck:event optional:optional];
}

+ (BOOL)customEventCheck:(NSDictionary *)event {
    if (event.count == 0) {
        return NO;
    }
    NSArray *protocol = [self.context arrayByAddingObjectsFromArray:@[@"eventName"]];
    NSArray *optional = @[@"path", @"pageShowTimestamp", @"attributes", @"query"];
    return [self protocolCheck:event protocol:protocol] && [self emptyPropertyCheck:event optional:optional];
}

+ (BOOL)loginUserAttributesEventCheck:(NSDictionary *)event {
    if (event.count == 0) {
        return NO;
    }
    NSArray *protocol = [self.context arrayByAddingObjectsFromArray:@[@"attributes"]];
    return [self protocolCheck:event protocol:protocol] && [self emptyPropertyCheck:event];
}

+ (BOOL)conversionVariablesEventCheck:(NSDictionary *)event {
    if (event.count == 0) {
        return NO;
    }
    NSArray *protocol = [self.context arrayByAddingObjectsFromArray:@[@"attributes"]];
    return [self protocolCheck:event protocol:protocol] && [self emptyPropertyCheck:event];
}

+ (BOOL)visitorAttributesEventCheck:(NSDictionary *)event {
    if (event.count == 0) {
        return NO;
    }
    NSArray *protocol = [self.context arrayByAddingObjectsFromArray:@[@"attributes"]];
    return [self protocolCheck:event protocol:protocol] && [self emptyPropertyCheck:event];
}

+ (BOOL)appCloseEventCheck:(NSDictionary *)event {
    if (event.count == 0) {
        return NO;
    }
    NSArray *protocol = self.context;
    return [self protocolCheck:event protocol:protocol] && [self emptyPropertyCheck:event];
}

+ (BOOL)pageAttributesEventCheck:(NSDictionary *)event {
    if (event.count == 0) {
        return NO;
    }
    NSArray *protocol = [self.context arrayByAddingObjectsFromArray:@[@"path", @"pageShowTimestamp", @"attributes"]];
    NSArray *optional = @[@"query"];
    return [self protocolCheck:event protocol:protocol] && [self emptyPropertyCheck:event optional:optional];
}

#pragma mark - Private Methods

/// 与测量协议对比，验证事件数据完整性
/// @param event 事件
/// @param protocol 测量协议字段数组
+ (BOOL)protocolCheck:(NSDictionary *)event protocol:(NSArray *)protocol {
    NSDictionary *dic = [NoburPoMeaProCheck compareArray:protocol toAnother:event.allKeys];
    if ([dic[@"chres"] isEqualToString:@"same"]) {
        return YES;
    } else if ([dic[@"chres"] isEqualToString:@"different"] && ((NSArray *)dic[@"reduce"]).count == 0) {
        return YES;
    } else {
        return NO;
    }
}

/// 验证事件必需字段不为空
/// @param event 事件
+ (BOOL)emptyPropertyCheck:(NSDictionary *)event {
    return [self emptyPropertyCheck:event optional:nil];
}

/// 验证事件必需字段不为空
/// @param event 事件
/// @param optional 其他可为空的字段数组
+ (BOOL)emptyPropertyCheck:(NSDictionary *)event optional:(NSArray *)optional {
    NSDictionary *dic = [NoburPoMeaProCheck checkDictEmpty:event];
    if ([dic[@"chres"] isEqualToString:@"Passed"]) {
        return YES;
    } else if ([dic[@"chres"] isEqualToString:@"Failed"]) {
        NSArray *emptyKeys = dic[@"EmptyKeys"];
        BOOL allEmptyKeysAreOptional = YES;
        for (NSString *key in emptyKeys) {
            BOOL thisEmptyKeyIsOptional = NO;
            for (NSString *optionalKey in self.contextOptional) {
                if ([optionalKey isEqualToString:key]) {
                    thisEmptyKeyIsOptional = YES;
                    break;
                }
            }
            if (!thisEmptyKeyIsOptional && optional.count > 0) {
                for (NSString *optionalKey in optional) {
                    if ([optionalKey isEqualToString:key]) {
                        thisEmptyKeyIsOptional = YES;
                        break;
                    }
                }
            }
            
            if (!thisEmptyKeyIsOptional) {
                allEmptyKeysAreOptional = NO;
                break;
            }
        }
        return allEmptyKeysAreOptional;
    } else {
        return NO;
    }
}

#pragma mark - Setter & Getter

+ (NSArray *)context {
    NSArray *context = @[@"platform",
                         @"platformVersion",
                         @"deviceId",
                         @"sessionId",
                         @"eventType",
                         @"timestamp",
                         @"domain",
                         @"urlScheme",
                         @"appState",
                         @"globalSequenceId",
                         @"eventSequenceId",
                         @"networkState",
                         @"screenHeight",
                         @"screenWidth",
                         @"deviceBrand",
                         @"deviceModel",
                         @"deviceType",
                         @"appVersion",
                         @"appName",
                         @"language",
                         @"sdkVersion"];
    return context;
}

+ (NSArray *)contextOptional {
    NSArray *contextOptional = @[@"userId",
                                 @"latitude",
                                 @"longitude",
                                 @"userKey"];
    return contextOptional;
}

@end

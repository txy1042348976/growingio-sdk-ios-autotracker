//
//  ManualTrackHelper.h
//  GIOAutoTests
//
//  Created by GrowingIO on 2018/6/6.
//  Copyright (C) 2018 Beijing Yishu Technology Co., Ltd.
//

#import <Foundation/Foundation.h>

@interface ManualTrackHelper : NSObject

@property (class, nonatomic, copy, readonly) NSArray *context;
@property (class, nonatomic, copy, readonly) NSArray *contextOptional;

//判断字典dicts是否包含关键字ckchar
+ (Boolean *)CheckContainsKey:(NSDictionary *)dicts:(NSString *)ckchar;

+ (BOOL)visitEventCheck:(NSDictionary *)event;

+ (BOOL)customEventCheck:(NSDictionary *)event;

+ (BOOL)loginUserAttributesEventCheck:(NSDictionary *)event;

+ (BOOL)conversionVariablesEventCheck:(NSDictionary *)event;

+ (BOOL)visitorAttributesEventCheck:(NSDictionary *)event;

+ (BOOL)appCloseEventCheck:(NSDictionary *)event;

+ (BOOL)pageAttributesEventCheck:(NSDictionary *)event;

@end

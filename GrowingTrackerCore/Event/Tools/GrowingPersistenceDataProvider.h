//
// GrowingPersistenceDataProvider.h
// GrowingAnalytics
//
//  Created by sheng on 2020/11/13.
//  Copyright (C) 2017 Beijing Yishu Technology Co., Ltd.
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


#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class GrowingEventSequenceObject;
@interface GrowingPersistenceDataProvider : NSObject


@property (nonatomic, strong) NSString *loginUserId;

+ (instancetype)sharedInstance;

- (void)setDeviceId:(NSString * _Nullable)deviceId;
- (NSString *)deviceId;

- (void)setLoginUserId:(NSString * _Nullable)loginUserId;
- (nullable NSString *)loginUserId;

- (void)setLoginUserKey:(NSString * _Nullable)loginUserKey;
- (nullable NSString *)loginUserKey;

///设置NSString,NSNumber(cdp、upgrade)
- (void)setString:(NSString *)value forKey:(NSString *)key;

- (NSString *)getStringforKey:(NSString *)key;

- (GrowingEventSequenceObject*)getAndIncrement:(NSString *)eventType;

//防止xcode编码提示使用KVC来获取值
- (void)setValue:(id _Nullable)value forKey:(NSString * _Nonnull)key UNAVAILABLE_ATTRIBUTE;
- (id)valueForKey:(NSString * _Nonnull)key UNAVAILABLE_ATTRIBUTE;

@end

@interface GrowingEventSequenceObject : NSObject
//全局 序列id
@property (nonatomic, assign) long long globalId;
//事件类型 序列id
@property (nonatomic, assign) long long eventTypeId;


@end

NS_ASSUME_NONNULL_END

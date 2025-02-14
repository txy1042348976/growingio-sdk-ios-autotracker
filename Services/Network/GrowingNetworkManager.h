//
//  GrowingNetworkManager.h
//  GrowingAnalytics
//
//  Created by GrowingIO on 2020/6/17.
//  Copyright (C) 2020 Beijing Yishu Technology Co., Ltd.
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
#import "GrowingRequestProtocol.h"
#import "GrowingEventNetworkService.h"

//@protocol GrowingEventNetworkService;
@protocol GrowingURLSessionProtocol;
@protocol GrowingURLSessionDataTaskProtocol;

typedef void ( ^GrowingNetworkSuccessBlock ) ( NSHTTPURLResponse * _Nonnull httpResponse , NSData * _Nullable data);
typedef void ( ^GrowingNetworkFailureBlock ) ( NSHTTPURLResponse * _Nonnull httpResponse , NSData * _Nullable data, NSError * _Nullable error );

NS_ASSUME_NONNULL_BEGIN

@interface GrowingNetworkManager : NSObject <GrowingEventNetworkService>

+ (instancetype)sharedInstance;

+ (instancetype)shareManagerURLSession:(id <GrowingURLSessionProtocol>)session;

- (id <GrowingURLSessionDataTaskProtocol>_Nullable)sendRequest:(id <GrowingRequestProtocol>)request
                                                       success:(GrowingNetworkSuccessBlock)success
                                                       failure:(GrowingNetworkFailureBlock)failure;


@end

NS_ASSUME_NONNULL_END

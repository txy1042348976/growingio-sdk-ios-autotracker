//
//  GrowingEventRequest.m
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


#import "GrowingEventRequest.h"
#import "GrowingNetworkConfig.h"
#import "GrowingEventRequestAdapter.h"
#import "GrowingRequestAdapter.h"
#import "GrowingRequestAdapter.h"
#import "NSString+GrowingHelper.h"
#import "GrowingConfigurationManager.h"
#import "GrowingTimeUtil.h"


@implementation GrowingEventRequest

@synthesize events;
@synthesize outsize;
@synthesize stm;

- (instancetype)initWithEvents:(NSData *)events {
    if (self = [super init]) {
        self.events = events;
        self.stm = [GrowingTimeUtil currentTimeMillis];
    }
    return self;
}

- (GrowingHTTPMethod)method {
    return GrowingHTTPMethodPOST;
}

- (NSURL *)absoluteURL {
    NSString *baseUrl = [GrowingNetworkConfig sharedInstance].growingApiHostEnd;
    if (!baseUrl.length) {
        return nil;
    }
    
    NSString *absoluteURLString = [baseUrl absoluteURLStringWithPath:self.path andQuery:self.query];
    return [NSURL URLWithString:absoluteURLString];
}

- (NSString *)path {
    NSString *accountId = [GrowingConfigurationManager sharedInstance].trackConfiguration.projectId ? : @"";
    NSString *path = [NSString stringWithFormat:@"v3/projects/%@/collect", accountId];
    return path;
}


- (NSArray<id<GrowingRequestAdapter>> *)adapters {
    GrowingEventRequestHeaderAdapter *eventHeaderAdapter = [[GrowingEventRequestHeaderAdapter alloc] init];
    GrowingRequestHeaderAdapter *basicHeaderAdapter = [GrowingRequestHeaderAdapter headerAdapterWithHeader:nil];
    GrowingRequestMethodAdapter *methodAdapter = [GrowingRequestMethodAdapter methodAdpterWithMethod:self.method];
    
    GrowingEventRequestJsonBodyAdpter *bodyAdapter = [GrowingEventRequestJsonBodyAdpter eventJsonBodyAdpter:self.events
                                                                                                  timestamp:self.stm
                                                                                               outsizeBlock:^(unsigned long long bodySize) {
        self.outsize = bodySize;
    }];
    
    NSMutableArray *adapters = [NSMutableArray arrayWithObjects:eventHeaderAdapter, basicHeaderAdapter, methodAdapter, bodyAdapter, nil];
    return adapters;
}

- (NSDictionary *)query {
    NSString *stm = [NSString stringWithFormat:@"%llu", self.stm];
    return @{@"stm" : stm};
}

@end

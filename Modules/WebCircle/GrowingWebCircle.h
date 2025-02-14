//
//  GrowingWebCircle.h
//  GrowingAnalytics
//
//  Created by 陈曦 on 15/8/26.
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
#import "GrowingModuleProtocol.h"
#import "GrowingNode.h"

@protocol GrowingWebSocketService;

@interface GrowingWebCircle : NSObject <GrowingModuleProtocol>

@property (nonatomic, strong) id <GrowingWebSocketService> webSocket;

@end

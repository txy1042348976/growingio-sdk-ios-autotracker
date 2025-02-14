//
//  UITabBarController+GrowingNode.m
//  GrowingAnalytics
//
//  Created by GrowingIO on 15/9/21.
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


#import "GrowingAttributesConst.h"
#import "UITabBarController+GrowingNode.h"
#import "UIViewController+GrowingNode.h"

@implementation UITabBarController (GrowingNode)

- (NSArray<id<GrowingNode>>*)growingNodeChilds {
    NSMutableArray *childs = [NSMutableArray array];
    if (self.presentedViewController) {
        [childs addObject:self.presentedViewController];
        return childs;
    }
    
    if (self.selectedViewController) {
        [childs addObject:self.selectedViewController];
    }
    
    if (self.isViewLoaded && [self.tabBar growingImpNodeIsVisible]) {
        [childs addObject:self.tabBar];
    }
    
    return childs;
}


- (CGRect)growingNodeFrame {
    return self.view.growingNodeFrame;
}

@end



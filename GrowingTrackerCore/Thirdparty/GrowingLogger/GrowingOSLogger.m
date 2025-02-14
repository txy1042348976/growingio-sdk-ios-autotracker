// Software License Agreement (BSD License)
//
// Copyright (c) 2010-2020, Deusty, LLC
// All rights reserved.
//
// Redistribution and use of this software in source and binary forms,
// with or without modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// * Neither the name of Deusty nor the names of its contributors may be used
//   to endorse or promote products derived from this software without specific
//   prior written permission of Deusty, LLC.

#import "GrowingOSLogger.h"
#import <os/log.h>

@interface GrowingOSLogger () {
    NSString *_subsystem;
    NSString *_category;
}

@property (copy, nonatomic, readonly, nullable) NSString *subsystem;
@property (copy, nonatomic, readonly, nullable) NSString *category;
@property (strong, nonatomic, readwrite, nonnull) os_log_t logger;

@end

@implementation GrowingOSLogger

@synthesize subsystem = _subsystem;
@synthesize category = _category;

#pragma mark - Initialization

/**
 * Assertion
 * Swift: (String, String)?
 */
- (instancetype)initWithSubsystem:(NSString *)subsystem category:(NSString *)category {
    NSAssert((subsystem == nil) == (category == nil), @"Either both subsystem and category or neither should be nil.");
    if (self = [super init]) {
        _subsystem = [subsystem copy];
        _category = [category copy];
    }
    return self;
}

static GrowingOSLogger *sharedInstance;

- (instancetype)init {
    return [self initWithSubsystem:nil category:nil];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t GrowingOSLoggerOnceToken;

    dispatch_once(&GrowingOSLoggerOnceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });

    return sharedInstance;
}

#pragma mark - os_log

- (os_log_t)getLogger {
    if (self.subsystem == nil || self.category == nil) {
        return OS_LOG_DEFAULT;
    }
    return os_log_create(self.subsystem.UTF8String, self.category.UTF8String);
}

- (os_log_t)logger {
    if (_logger == nil)  {
        _logger = [self getLogger];
    }
    return _logger;
}

#pragma mark - GrowingLogger

- (GrowingLoggerName)loggerName {
    return GrowingLoggerNameOS;
}

- (void)logMessage:(GrowingLogMessage *)logMessage {
    // Skip captured log messages
    if ([logMessage->_fileName isEqualToString:@"GrowingASLLogCapture"]) {
        return;
    }

    if (@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)) {
        NSString * message = _logFormatter ? [_logFormatter formatLogMessage:logMessage] : logMessage->_message;
        if (message != nil) {
            const char *msg = [message UTF8String];
            __auto_type logger = [self logger];
            switch (logMessage->_flag) {
                case GrowingLogFlagError  :
                    os_log_error(logger, "%{public}s", msg);
                    break;
                case GrowingLogFlagWarning:
                case GrowingLogFlagInfo   :
                    os_log_info(logger, "%{public}s", msg);
                    break;
                case GrowingLogFlagDebug  :
                case GrowingLogFlagVerbose:
                default              :
                    os_log_debug(logger, "%{public}s", msg);
                    break;
            }
        }
    }
}

@end

//
//  MFIBoltDoNotDisturbConfiguration.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 1/21/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFIBoltCommonType.h"
@class MFIBoltMisfitController;

#define MFIBoltSetDoNotDisturbConfiguration(start, end, on) [MFIBoltDoNotDisturbConfiguration doNotDisturbConfigurationWithStartTime:start endTime:end turnOn:on]

@interface MFIBoltDoNotDisturbConfiguration : NSObject

/*!
 * Start time.
 */
@property (nonatomic) TIME start;

/*!
 * End time.
 */
@property (nonatomic) TIME end;

/*!
 * Switch value. YES if do not disturb is turned on. Otherwise, turned off.
 */
@property (nonatomic) BOOL on;

+ (instancetype)doNotDisturbConfigurationWithStartTime:(TIME)start
                                               endTime:(TIME)end
                                                turnOn:(BOOL)on;

@end

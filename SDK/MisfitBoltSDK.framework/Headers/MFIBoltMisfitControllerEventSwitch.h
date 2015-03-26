//
//  MFIBoltMisfitControllerEventSwitch.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 1/7/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFIBoltMisfitControllerEvent.h"

#define MFIBoltMisfitControllerEventSwitchMake(event, actionIndex, on) [MFIBoltMisfitControllerEventSwitch eventSwitchWithEvent:event action:actionIndex turnOn:on]

@interface MFIBoltMisfitControllerEventSwitch : MFIBoltMisfitControllerEvent

/*!
 * Switch value.
 */
@property (nonatomic, readonly) BOOL on;

+ (instancetype)eventSwitchWithEvent:(uint8_t)event
                              action:(uint8_t)action
                              turnOn:(BOOL)on;
@end

//
//  MFIBoltMisfitControllerEventColorTemperature.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 1/7/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFIBoltMisfitControllerEvent.h"

#define MFIBoltMisfitControllerEventColorTemperatureMake(event, actionIndex, color, brightnessColor) [MFIBoltMisfitControllerEventColorTemperature eventColorTemperatureWithEvent:event action:actionIndex colorTemperature:color brightness:brightnessColor]

@interface MFIBoltMisfitControllerEventColorTemperature : MFIBoltMisfitControllerEvent

/*!
 * Color temperature value (from 1700 to 10000).
 */
@property (nonatomic, readonly) uint16_t colorTemperature;

/*!
 * Brightness value (from 0 to 100).
 */
@property (nonatomic, readonly) uint8_t brightness;

+ (instancetype)eventColorTemperatureWithEvent:(uint8_t)event
                                        action:(uint8_t)action
                              colorTemperature:(uint16_t)colorTemperature
                                    brightness:(uint8_t)brightness;
@end

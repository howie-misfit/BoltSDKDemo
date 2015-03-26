//
//  MFIBoltMisfitControllerEventColorRGB.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 1/7/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFIBoltMisfitControllerEvent.h"
#import "MFIBoltCommonType.h"

#define MFIBoltMisfitControllerEventColorRGBMake(event, actionIndex, colorRGB, brightnessColor) [MFIBoltMisfitControllerEventColorRGB eventColorRGBWithEvent:event action:actionIndex color:colorRGB brightness:brightnessColor]

@interface MFIBoltMisfitControllerEventColorRGB : MFIBoltMisfitControllerEvent

/*!
 * RGB Color value.
 */
@property (nonatomic, readonly) RGB color;

/*!
 * Brightness value (from 0 to 100).
 */
@property (nonatomic, readonly) uint8_t brightness;

+ (instancetype)eventColorRGBWithEvent:(uint8_t)event
                                action:(uint8_t)action
                                 color:(RGB)color
                            brightness:(uint8_t)brightness;

@end

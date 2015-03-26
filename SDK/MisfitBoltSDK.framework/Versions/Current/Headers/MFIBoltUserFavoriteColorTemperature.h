//
//  MFIBoltUserFavoriteColorTemperature.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 1/21/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MFIBoltSetUserFavoriteColorTemperature(colorTemperature, brightnessColor, distanceRSSI) [MFIBoltUserFavoriteColorTemperature userFavoriteColorTemperature:colorTemperature brightness:brightnessColor distance:distanceRSSI]

@class MFIBoltMisfitController;

@interface MFIBoltUserFavoriteColorTemperature : NSObject

/*!
 * Color temperature value (from 1700 to 10000).
 */
@property (nonatomic) uint16_t colorTemperature;

/*!
 * Brightness value (from 0 to 100).
 */
@property (nonatomic) uint8_t brightness;

/*!
 * Distance value (from 60 to 100).
 * It is strength's signal.
 */
@property (nonatomic) uint8_t distance;

+ (instancetype)userFavoriteColorTemperature:(uint16_t)colorTemperature
                                  brightness:(uint8_t)brightness
                                    distance:(uint8_t)distance;
@end

//
//  MFIBoltMisfitControllerEvent.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 1/7/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @enum MFIBoltMisfitControllerEventMode
 *
 * @discussion represent types of MisfitController events mode.
 *
 * @constant   MFIBoltMisfitControllerEventModeSwitch              Mode Switch.
 * @constant   MFIBoltMisfitControllerEventModeColorRGB            Mode color RGB.
 * @constant   MFIBoltMisfitControllerEventModeColorTemperature    Mode color temperature.
 */
typedef NS_ENUM(uint8_t, MFIBoltMisfitControllerEventMode)
{
    MFIBoltMisfitControllerEventModeSwitch = 1,
    MFIBoltMisfitControllerEventModeColorRGB = 2,
    MFIBoltMisfitControllerEventModeColorTemperature = 3,
};

@interface MFIBoltMisfitControllerEvent : NSObject

/*!
 * Event index (range from 0 to 255).
 */
@property (nonatomic, readonly) uint8_t event;

/*!
 * Action index (range from 1 to 3).
 */
@property (nonatomic, readonly) uint8_t action;

/*!
 * Event mode (See also at MFIBoltMisfitControllerEventMode enum).
 */
@property (nonatomic, readonly) MFIBoltMisfitControllerEventMode mode;

@end

//
//  MFIBoltMisfitControllerConfiguration.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 2/13/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFIBoltMisfitController;
@class MFIBoltUserFavoriteColorTemperature;
@class MFIBoltDoNotDisturbConfiguration;

#define MFIBoltMisfitControllerConfigurationMake(misfitController, misfitControllerEvents, doNotDisturbConfiguration, colorTemperature) [MFIBoltMisfitControllerConfiguration misfitControllerConfigurationWithMisfitController:misfitController events:misfitControllerEvents doNotDisturb:doNotDisturbConfiguration userFavoriteColorTemperature:colorTemperature]

@interface MFIBoltMisfitControllerConfiguration : NSObject

/*!
 * MisfitController
 */
@property (nonatomic) MFIBoltMisfitController *misfitController;

/*!
 * MisfitController events. (See also at classes MFIBoltMisfitControllerEventSwitch,
 *                           MFIBoltMisfitControllerEventColorRGB,
 *                           MFIBoltMisfitControllerEventColorTemperature).
 */
@property (nonatomic) NSMutableArray *events;

/*!
 * Do not disturb configuration.
 */
@property (nonatomic) MFIBoltDoNotDisturbConfiguration *doNotDisturb;

/*!
 * User's favorite color configuration (Proximity).
 */
@property (nonatomic) MFIBoltUserFavoriteColorTemperature *userFavoriteColorTemperature;

+ (instancetype)misfitControllerConfigurationWithMisfitController:(MFIBoltMisfitController *)controller
                                                           events:(NSMutableArray *)events
                                                     doNotDisturb:(MFIBoltDoNotDisturbConfiguration *)doNotDisturb
                                     userFavoriteColorTemperature:(MFIBoltUserFavoriteColorTemperature *)userFavoriteColorTemperature;

@end

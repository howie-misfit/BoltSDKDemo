//
//  MFIBoltDevice+BasicConfig.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 3/5/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import "MFIBoltDevice.h"

@interface MFIBoltDevice (BasicConfig)

#pragma mark - Connection

/*!
 * Establish connection to Bolt.
 *
 * @param timeoutInterval    Timeout interval in seconds. If pass 0, it will wait for the connection indefinitely.
 *
 * @return  NO if it is already connected. Otherwise, YES.
 */
- (BOOL)connectWithTimeoutInterval:(NSTimeInterval)timeoutInterval
                        completion:(MFIBoltConnectionCompletion)completion;

/*!
 * Disconnect.
 *
 * @return  NO if it is already disconnected. Otherwise, YES.
 */
- (BOOL)disconnectWithCompletion:(MFIBoltDisconnectionCompletion)completion;

/*!
 * Getting everything ready for other operations.
 *
 * @return  YES if the preparation is started successfully. Otherwise, return NO.
 */
- (BOOL)prepareWithCompletion:(MFIBoltPreparationCompletion)completion;

/*!
 * Turn on/off the LED (NOT power on/off). 
 * - Turn off: set the brightness to 0. 
 * - Turn on: restore previous brightness level.
 *
 * @param on                 YES if you wanna turn on bulb. Otherwise, NO.
 * @return                   NO if method isn't called successful. Otherwise, YES.
 */
- (BOOL)switchBulb:(BOOL)on
        completion:(MFIBoltActionCompletion)completion;

/*!
 * Set RGB color.
 *
 * @param rgb           color in red, green, blue (each range from 0 to 255).
 * @param brightness    brightness (range from 0 to 100).
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)setColorRGB:(RGB)rgb
         brightness:(uint8_t)brightness
         completion:(MFIBoltActionCompletion)completion;

/*!
 * Set temperature color.
 *
 * @param colorTemperature      color temperature (range from 1700 to 10000).
 * @param brightness            brightness (range from 0 to 100).
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)setColorTemperature:(uint16_t)colorTemperature
                 brightness:(uint8_t)brightness
                 completion:(MFIBoltActionCompletion)completion;

/*!
 * Switch gradual mode
 *
 * @param on        YES if you wanna turn on gradual mode. Otherwise, NO.
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)switchGradualMode:(BOOL)on
               completion:(MFIBoltActionCompletion)completion;

/*!
 * Set current color to be default. 
 * Bulbs automatically change to the default color when powered on.
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)setDefaultColorWithCompletion:(MFIBoltActionCompletion)completion;

/*!
 * Set name.
 *
 * @param name      name of the bulb (max length is 65 characters).
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)setName:(NSString *)name
     completion:(MFIBoltActionCompletion)completion;

/*!
 * Get the bulb's name.
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)getNameWithCompletion:(MFIBoltPropertyCompletion)completion;

/*!
 * Get bulb's color status.
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)getColorStatusWithCompletion:(MFIBoltColorStatusCompletion)completion;

/*!
 * Get bulb's mac address.
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)getMacAddressWithCompletion:(MFIBoltPropertyCompletion)completion;

/*!
 * Get bulb's firmware version.
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)getFirmwareVersionWithCompletion:(MFIBoltPropertyCompletion)completion;

/*!
 * Get bulb's serial number.
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)getSerialNumberWithCompletion:(MFIBoltPropertyCompletion)completion;

/*!
 * Refresh strength's signal.
 *
 * @return YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)refreshRSSI;

/*!
 * Update firmware.
 *
 * @param data      Binary data of firmware.
 * @return          YES if function was called successfully. Otherwise, return NO.
 */
- (BOOL)updateFirmwareWithBinary:(NSData *)data;

@end

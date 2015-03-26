//
//  MFIBoltDevice.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 10/23/14.
//  Copyright (c) 2014 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFIBoltCommonType.h"

@class MFIBoltDisconnectionError;
@class MFIBoltConnectionError;
@class MFIBoltOADError;
@class MFIBoltPreparationError;
@class MFIBoltActionError;

@class MFIBoltDevice;

@class MFIBoltMisfitController;
@class MFIBoltMisfitControllerConfiguration;

@protocol MFIBoltDeviceConnectionDelegate <NSObject>

/*!
 * Connection state has changed.
 *
 * @param boltDevice    target device.
 * @param error         cause of failure.
 */
- (void)boltDevice:(MFIBoltDevice *)boltDevice didDisconnectUnexpectedWithError:(MFIBoltDisconnectionError *)error;

/*!
 * RSSI has refreshed. Invoked when operation refreshRSSI: completed.
 * The result will be updated at property "RSSI".
 *
 * @param boltDevice    target device.
 * @param error         cause of failure. NIL if refresh succeeded.
 */
- (void)boltDevice:(MFIBoltDevice *)boltDevice didRefreshRSSIWithError:(NSError *)error;

@end

@protocol MFIBoltDeviceOADDelegate <NSObject>

/*!
 * Firmware update progress has changed.
 *
 * @param boltDevice    target device.
 * @param progress      the current progress (from 0 to 100).
 */
- (void)boltDevice:(MFIBoltDevice *)boltDevice firmwareUpdateDidChangeProgress:(float)progress;

/*!
 * Firmware update completed.
 *
 * @param boltDevice    target device.
 * @param error         cause of failure. NIL if update succeeded.
 */
- (void)boltDevice:(MFIBoltDevice *)boltDevice firmwareUpdateCompletedWithError:(MFIBoltOADError *)error;

@end

/*!
 * @enum MFIBoltDeviceState
 *
 * @discussion represent the current state of device.
 *
 * @constant   MFIBoltDeviceStateDisconnected  Disconnected.
 * @constant   MFIBoltDeviceStateDisconnecting Disconnecting.
 * @constant   MFIBoltDeviceStateConnecting    Connecting.
 * @constant   MFIBoltDeviceStateConnected     Connected.
 * @constant   MFIBoltDeviceStateUpdating      Updating firmware.
 * @constant   MFIBoltDeviceStatePreparing     Getting ready for other operations.
 * @constant   MFIBoltDeviceStateReady         Ready.
 * @constant   MFIBoltDeviceStateBusy          Executing an operation.
 */
typedef NS_ENUM (NSUInteger, MFIBoltDeviceState)
{
    MFIBoltDeviceStateDisconnected,
    MFIBoltDeviceStateDisconnecting,
    MFIBoltDeviceStateConnecting,
    MFIBoltDeviceStateConnected,
    MFIBoltDeviceStateUpdating,
    MFIBoltDeviceStatePreparing,
    MFIBoltDeviceStateReady,
    MFIBoltDeviceStateBusy,
};

/*!
 * @enum MFIBoltDeviceColorMode
 *
 * @discussion represent the current color mode of device.
 *
 * @constant   MFIBoltDeviceColorModeRGB            RGB color mode.
 * @constant   MFIBoltDeviceColorModeTemperature    Temperature color mode.
 */
typedef NS_ENUM(NSUInteger, MFIBoltDeviceColorMode)
{
    MFIBoltDeviceColorModeRGB,
    MFIBoltDeviceColorModeTemperature,
};

/*!
 * Invoked when completed an action.
 *
 * @param boltDevice    target device.
 * @param error         cause of failure. nil If action succeeded.
 */
typedef void (^MFIBoltActionCompletion)(MFIBoltDevice *boltDevice, MFIBoltActionError *error);

/*!
 * Invoked when a connection device is completed.
 *
 * @param boltDevice     target device.
 * @param error          cause of failure. NIL if connection succeeded.
 */
typedef void (^MFIBoltConnectionCompletion)(MFIBoltDevice *boltDevice, MFIBoltConnectionError *error);

/*!
 * Invoked when completed a disconnection device.
 *
 * @param boltDevice     target device.
 */
typedef void (^MFIBoltDisconnectionCompletion)(MFIBoltDevice *boltDevice);

/*!
 * Invoked when completed a preparation device.
 *
 * @param boltDevice    target device.
 * @param error         cause of failure. NIL if preparation succeeded.
 */
typedef void (^MFIBoltPreparationCompletion)(MFIBoltDevice *boltDevice, MFIBoltPreparationError *error);

/*!
 * Invoked when completed configuration MisfitController.
 *
 * @param boltDevice                        target device.
 * @param misfitControllerConfiguration     configuration of MisfitController.
 * @param error                             cause of failure. NIL if preparation succeeded.
 */
typedef void (^MFIBoltConfigMisfitControllerCompletion)(MFIBoltDevice *boltDevice,
                                                        MFIBoltMisfitControllerConfiguration *misfitControllerConfiguration,
                                                        MFIBoltActionError *error);

/*!
 * Invoked when completed switch beacon controller and proximity.
 *
 * @param boltDevice                    target device.
 * @param isBeaconControllerEnabled     YES if beacon controller was enabled. Otherwise, NO.
 * @param isProximityEnabled            YES if beacon controller was enabled. Otherwise, NO.
 * @param error                         cause of failure. NIL if action succeeded.
 */
typedef void (^MFIBoltSwitchOfBeaconControllerAndProximityCompletion)(MFIBoltDevice *boltDevice,
                                                                      BOOL isBeaconControllerEnabled,
                                                                      BOOL isProximityEnabled,
                                                                      MFIBoltActionError *error);

/*!
 * Invoked when completed get MisfitControllers.
 *
 * @param boltDevice                    target device.
 * @param misfitControllers             all MisfitControllers was included into bolt.
 * @param error                         cause of failure. NIL if action succeeded.
 */
typedef void (^MFIBoltGetMisfitControllersCompletion)(MFIBoltDevice *boltDevice,
                                                      NSArray *misfitControllers,
                                                      MFIBoltActionError *error);

/*!
 * Invoked when completed get property.
 *
 * @param boltDevice                    target device.
 * @param property                      string value of property.
 * @param error                         cause of failure. NIL if action succeeded.
 */
typedef void (^MFIBoltPropertyCompletion)(MFIBoltDevice *boltDevice,
                                          NSString *property,
                                          MFIBoltActionError *error);

/*!
 * Invoked when completed get color status.
 *
 * @param boltDevice                    target device.
 * @param mode                          current mode.
 * @param colorValue                    value ('uint16_t' if Bolt in color temperature mode. Otherwise, it have type 'RGB)
 * @param brightness                    brightness value.
 * @param error                         cause of failure. NIL if action succeeded.
 */
typedef void (^MFIBoltColorStatusCompletion)(MFIBoltDevice *boltDevice,
                                             MFIBoltDeviceColorMode mode,
                                             void *colorValue,
                                             uint8_t brightness,
                                             MFIBoltActionError *error);

@interface MFIBoltDevice : NSObject

/*!
 * To be notify when connection state changed.
 */
@property id<MFIBoltDeviceConnectionDelegate> delegate;

/*!
 * To be notify while OAD is occurring.
 */
@property id<MFIBoltDeviceOADDelegate> oadDelegate;

/*!
 * State of device.
 */
@property (nonatomic, readonly) MFIBoltDeviceState state;

/*!
 * Bluetooth advertised name.
 */
@property (nonatomic, readonly) NSString *bluetoothName;

/*!
 * UUID string of device.
 */
@property (nonatomic, readonly) NSString *uuidString;

/*!
 * Latest strength's signal received.
 */
@property (nonatomic, readonly) NSNumber *RSSI;

@end

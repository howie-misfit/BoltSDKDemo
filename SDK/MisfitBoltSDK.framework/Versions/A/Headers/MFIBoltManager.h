//
//  MFIBoltAdapter.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 10/23/14.
//  Copyright (c) 2014 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFIBoltDevice.h"
@import CoreBluetooth;

@protocol MFIBoltManagerDelegate <NSObject>

/*!
 * A device is discovered.
 *
 * Strength's signal will be updated at property "RSSI" into class MFIBoltDevice.
 *
 * @param device    the device discovered.
 * @param RSSI      signal's strength.
 */
- (void)didDiscoverDevice:(MFIBoltDevice *)device RSSI:(NSNumber *)RSSI;

/*!
 * Central manager state is updated.
 * The new state can be accessed via property "state". See also CBCentralManagerState.
 */
- (void)centralManagerDidUpdateState;

/*!
 * Scanning was stopped unexpectedly due to Bluetooth being disabled.
 */
- (void)scanDidStopUnexpectedly;

@end

/*!
 * Invoked when completed retrieved devices.
 *
 * @param devices       Array of devices was retrieved.
 */
typedef void(^MFIBoltManagerRetrieveCompletion)(NSArray *devices);

@interface MFIBoltManager : NSObject

/*!
 * Delegate to receive scanning result and other events.
 */
@property id<MFIBoltManagerDelegate> delegate;

/*!
 * Central manager state.
 */
@property (nonatomic, readonly) CBCentralManagerState state;

/*!
 * Whether there is a scanning session in progress.
 */
@property (nonatomic, readonly) BOOL isScanning;

/*!
 * Get shared instance of MFIBoltManager.
 *
 * @return shared instance of MFIBoltManager.
 */
+ (MFIBoltManager *)sharedInstance;

/*!
 * Start scan for devices.
 *
 * @return YES if succeed. NO when central manager is not ready yet or there is already a scanning session in progress.
 */
- (BOOL)startScan;

/*!
 * Stop scan devices.
 */
- (void)stopScan;

/*!
 * Retrieve devices with identifiers string.
 * Assume that identifiers string belong to Bolt devices.
 *
 * @param identifiers      array of Bolt's identifier strings.
 */
- (void)retrieveDevicesWithIdentifiers:(NSArray *)identifiers
                            completion:(MFIBoltManagerRetrieveCompletion)completion;

@end

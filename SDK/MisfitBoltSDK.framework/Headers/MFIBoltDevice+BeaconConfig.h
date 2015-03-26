//
//  MFIBoltDevice+BeaconConfig.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 3/5/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import "MFIBoltDevice.h"

@interface MFIBoltDevice (BeaconConfig)

/*!
 * Switch beacon controller.
 *
 * @param enable      YES if you wanna enable. Otherwise, NO.
 * @return            YES if method was called successfully. Otherwise, return NO.
 */
- (BOOL)switchBeaconController:(BOOL)enable
                    completion:(MFIBoltActionCompletion)completion;

/*!
 * Switch proximity function.
 *
 * @param enable      YES if you wanna enable. Otherwise, NO.
 * @return            YES if method was called successfully. Otherwise, return NO.
 */
- (BOOL)switchProximity:(BOOL)enable
             completion:(MFIBoltActionCompletion)completion;

/*!
 * Set configuration for MisfitController.
 *
 * @param misfitControllerConfiguration     configuration of MisfitController.
 * @return                                  YES if method was called successfully. Otherwise, return NO.
 */
- (BOOL)setMisfitControllerConfiguration:(MFIBoltMisfitControllerConfiguration *)misfitControllerConfiguration
                              completion:(MFIBoltActionCompletion)completion;

/*!
 * Get configuration of MisfitController.
 *
 * @param misfitController      the device used to control the bulb.
 * @return                      YES if method was called successfully. Otherwise, return NO.
 */
- (BOOL)getConfigurationWithMisfitController:(MFIBoltMisfitController *)misfitController
                                  completion:(MFIBoltConfigMisfitControllerCompletion)completion;

/*!
 * Get status of switch beacon controller and proximity.
 *
 * @return            YES if method was called successfully. Otherwise, return NO.
 */
- (BOOL)getSwitchOfBeaconControllerAndProximityWithCompletion:(MFIBoltSwitchOfBeaconControllerAndProximityCompletion)completion;

/*!
 * Get MisfitControllers.
 *
 * @return            YES if method was called successfully. Otherwise, return NO.
 */
- (BOOL)getMisfitControllersWithCompletion:(MFIBoltGetMisfitControllersCompletion)completion;

/*!
 * Delete all MisfitControllers.
 *
 * @return            YES if method was called successfully. Otherwise, return NO.
 */
- (BOOL)deleteAllMisfitControllersWithCompletion:(MFIBoltActionCompletion)completion;

/*!
 * Delete MisfitController.
 *
 * @param misfitController            the device used to control the bulb.
 * @return                            YES if method was called successfully. Otherwise, return NO.
 */
- (BOOL)deleteMisfitController:(MFIBoltMisfitController *)misfitController
                    completion:(MFIBoltActionCompletion)completion;
@end

//
//  MFIBoltMisfitController.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 1/7/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MFIBoltMisfitControllerMake(sourceType, macAddressDevice) [MFIBoltMisfitController misfitControllerWithSourceType:sourceType macAddress:macAddressDevice]

/*!
 * @enum MFIBoltMisfitControllerSourceType
 *
 * @discussion represent types of MisfitController source type
 *
 * @constant   MFIBoltMisfitControllerSourceTypeUnknown     Unknown device.
 * @constant   MFIBoltMisfitControllerSourceTypeShine       Shine device.
 * @constant   MFIBoltMisfitControllerSourceTypeFlash       Flash device.
 */
typedef NS_ENUM(uint8_t, MFIBoltMisfitControllerSourceType)
{
    MFIBoltMisfitControllerSourceTypeUnknown,
    MFIBoltMisfitControllerSourceTypeShine,
    MFIBoltMisfitControllerSourceTypeFlash,
};

@interface MFIBoltMisfitController : NSObject <NSCopying>

/*!
 * Mac address (6 bytes).
 */
@property (nonatomic, readonly) NSData *macAddress;

/*!
 * Source type (See also at MFIBoltMisfitControllerSourceType enum).
 */
@property (nonatomic, readonly) MFIBoltMisfitControllerSourceType sourceType;

+ (instancetype)misfitControllerWithSourceType:(MFIBoltMisfitControllerSourceType)sourceType
                                    macAddress:(NSData *)macAddress;

@end

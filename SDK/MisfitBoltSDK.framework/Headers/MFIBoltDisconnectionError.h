//
//  MFIBoltDisDisconnectionError.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 1/17/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const kDisconnectionErrorDomain;

typedef NS_ENUM(NSUInteger, MFIBoltDisconnectionErrorCode)
{
    MFIBoltDisconnectionErrorCodeUpdatedFirmware,
    MFIBoltDisconnectionErrorCodeUnexpectedly,
};

@interface MFIBoltDisconnectionError : NSError

- (instancetype)initWithCode:(MFIBoltDisconnectionErrorCode)code;

- (instancetype)initWithCode:(MFIBoltDisconnectionErrorCode)code
             underlyingError:(NSError *)error;

@end

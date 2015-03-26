//
//  MFIBoltOADError.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 11/26/14.
//  Copyright (c) 2014 Misfit. All rights reserved.
//


#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const kOADErrorDomain;

typedef NS_ENUM(NSUInteger, MFIBoltOADErrorCode)
{
    MFIBoltOADErrorCodeTimeout,
    MFIBoltOADErrorCodeFailed,
    MFIBoltOADErrorCodeDisconnectUnexpectedly,
    MFIBoltOADErrorCodeDataEmpty,
    MFIBoltOADErrorCodeDataInvalid,
    MFIBoltOADErrorCodeNotFoundCharacteristics,
};

@interface MFIBoltOADError : NSError

- (instancetype)initWithCode:(MFIBoltOADErrorCode)code
             underlyingError:(NSError *)error;

- (instancetype)initWithCode:(MFIBoltOADErrorCode)code;
@end
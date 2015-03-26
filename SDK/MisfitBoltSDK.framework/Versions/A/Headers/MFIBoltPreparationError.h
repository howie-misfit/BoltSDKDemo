//
//  MFIBoltPreparationError.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 11/23/14.
//  Copyright (c) 2014 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const kPreparationErrorDomain;

typedef NS_ENUM(NSUInteger, MFIBoltPreparationErrorCode)
{
    MFIBoltPreparationErrorCodeTimeout,
    MFIBoltPreparationErrorCodeFailed,
    MFIBoltPreparationErrorCodePrepared,
    MFIBoltPreparationErrorCodeOADMode
};

@interface MFIBoltPreparationError : NSError

- (instancetype)initWithCode:(MFIBoltPreparationErrorCode)code;

- (instancetype)initWithCode:(MFIBoltPreparationErrorCode)code
             underlyingError:(NSError *)error;

@end


//
//  MFIBoltConnectionError.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 11/23/14.
//  Copyright (c) 2014 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const kConnectionErrorDomain;

typedef NS_ENUM(NSUInteger, MFIBoltConnectionErrorCode)
{
    MFIBoltConnectionErrorCodeConnectingFailed,
    MFIBoltConnectionErrorCodeTimeout,
};

@interface MFIBoltConnectionError : NSError

- (instancetype)initWithCode:(MFIBoltConnectionErrorCode)code;

- (instancetype)initWithCode:(MFIBoltConnectionErrorCode)code
             underlyingError:(NSError *)error;

@end


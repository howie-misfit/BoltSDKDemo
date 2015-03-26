//
//  MFIBoltActionError.h
//  MisfitBoltSDK
//
//  Created by Nghia Nguyen on 11/23/14.
//  Copyright (c) 2014 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MFIBoltActionErrorMake(code) [[MFIBoltActionError alloc] initWithCode:code]
#define MFIBoltActionUnderlyingErrorMake(code, error) [[MFIBoltActionError alloc] initWithCode:code underlyingError:error]

FOUNDATION_EXPORT NSString * const kActionErrorDomain;

typedef NS_ENUM(NSUInteger, MFIBoltActionErrorCode)
{
    MFIBoltActionErrorCodeTimeout,
    MFIBoltActionErrorCodeFailed
};

@interface MFIBoltActionError : NSError

- (instancetype)initWithCode:(MFIBoltActionErrorCode)code;

- (instancetype)initWithCode:(MFIBoltActionErrorCode)code
             underlyingError:(NSError *)error;

@end

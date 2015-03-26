//
//  FirmwareVersionViewController.h
//  MisfitBoltSDKDemo
//
//  Created by Nghia Nguyen on 2/12/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  FirmwareVersionViewControllerDelegate<NSObject>

- (void)choosedAFirmwareVersionWithPath:(NSURL *)url;

@end

@interface FirmwareVersionViewController : UIViewController

@property id<FirmwareVersionViewControllerDelegate> delegate;

@end

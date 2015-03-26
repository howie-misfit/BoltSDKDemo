//
//  MisfitControllerListViewController.h
//  MisfitBoltSDKDemo
//
//  Created by Nghia Nguyen on 2/27/15.
//  Copyright (c) 2015 Misfit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MFIBoltDevice;
@interface MisfitControllerListViewController : UIViewController

@property (nonatomic, weak) MFIBoltDevice *device;

@end
